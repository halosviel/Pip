--[=[
	[INFO]
	author: halosviel
	created: 2026 May 19
	
	[DESCRIPTION]
	Starts a timer in a different thread, emitting a warn for every defined
	milestone that passes by.
	
	Used for logging when processes take too long. Returns a class with
	exit/Destroy methods that stops and cleans up the timer.
	
	[EXAMPLES]
	local timer = processTimer.new("PROCESS_NAME", function()
		timer = nil
	end)
	
	[NOTES]
	- The class self-destructs if the last milestone is reached.
	- The cleanup handler is for GC'ing the class if the timer auto-exits.
	- Screaming snake case should be used for process names for standard.
]=]

-- [CONFIG]
local MESSAGE = "PROCESS :: Process \"%s\" is taking longer than expected (%is)"
local MILESTONES = { 10, 30, 60, 120, 300, 600, 1000 }

-- [REQUIRES]
local class = require("./class")
local console = require("./console")
local params = require("./params")

-- [TYPES]
type self = {
	-- [ENTRIES]
	processName: string,
	cleanupCallback: () -> nil,
	startTimestamp: number,
	connection: RBXScriptConnection?,
	
	-- [FUNCTIONS]
	new: ( self: self ) -> self,
	exit: ( self: self ) -> nil,
	Destroy: ( self: self ) -> nil,
	ready: ( self: self ) -> nil
}
export type ProcessTimer = self

-->

return class {
	new = function(self: self, processName: string, cleanupCallback: () ->  nil) : self
		params.expect("string", processName)
		params.expect("function", cleanupCallback)
		
		self.processName = processName
		self.cleanupCallback = cleanupCallback
		self.startTimestamp = os.clock()
		self.connection = nil
		
		--# assign exit as an alias to Destroy()
		self.exit = self.Destroy
		
		return self
	end,
	
	Destroy = function(self: self)
		if self.connection then
			self.connection:Disconnect()
			self.connection = nil
		end

		self.cleanupCallback() --# gc the class from within
		
		setmetatable(self, nil)
		table.clear(self)
	end,
	
	ready = function(self: self)
		local nextIndex: number = 1
		self.connection = game.RunService.Heartbeat:Connect(function()
			local nextMilestone: number = MILESTONES[nextIndex] or 0
			if os.clock() - self.startTimestamp >= nextMilestone then
				console.warn(MESSAGE:format(self.processName, nextMilestone))
				nextIndex += 1
				
				if MILESTONES[nextIndex] == nil then
					console.warn(`PROCESS :: Process "{self.processName}" exited after {MILESTONES[nextIndex - 1]}s`)
					self:exit()
				end
			end
		end)
	end,
} :: self