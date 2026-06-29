--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	Module loader for the framework. Require services using import.
	
	A separate timer will run in the background and emit warns if the
	boot process takes too long.
	
	[NOTES]
	- There is no guard for same-name modules - will warn instead.
	- Shallow search is used for the services folder.
	- Should only be called once per boundary!!
]=]

-- [REQUIRES]
local console = require("./console")
local params = require("./params")
local processTimer = require("./processTimer")
local try = require("./try")

-- [TYPES]
type Module = {
	constructor: () -> nil,
	ready: () -> nil
}
type self = {
	modules: { any },
	start: ( self: self, services: Folder ) -> nil
}

-->

return {
	modules = {},
	
	start = function(self: self, services: Folder)
		params.expect("Folder", services)
		
		local moduleScripts: { ModuleScript } = services:GetChildren()
		if #moduleScripts == 0 then
			console.warn("Services folder is empty")
			return
		end
		
		--# process timer
		local startTimestamp = os.clock()
		local bootTimer: processTimer.ProcessTimer?
		bootTimer = processTimer.new(`BOOT_PROCESS_{game.RunService:IsServer() and "SERVER" or "CLIENT"}`, function()
			bootTimer = nil
		end)
		
		--# cache & constructor
		for _, moduleScript: ModuleScript in moduleScripts do
			if not moduleScript:IsA("ModuleScript") then
				continue
			end
			if moduleScript.Name == "_types" then
				continue
			end
			
			local moduleName = moduleScript.Name
			
			local module: Module
			local moduleRequired: boolean = try {
				function()
					module = require(moduleScript) --# stupid type; ignore ts
				end,
				function(err: string)
					console.warn(`Failed to require {moduleName}`, `Err: {err}`, "Skipping...")
				end,
			}
			if not moduleRequired then
				continue
			end
			
			params.expect("table", module)
			params.expect("function", module.constructor)
			params.expect("function", module.ready)
			
			--# register
			if self.modules[moduleName] ~= nil then
				console.warn(`Duplicate of {moduleName} found`, "Skipping...")
				continue
			end
			self.modules[moduleName] = module
		end
		
		--# call constructor
		for moduleName: string, module: Module in self.modules do
			try {
				function()
					module:constructor()
				end,
				function(err: string)
					console.warn(`{moduleName} constructor callback failure`, `Err: {err}`, "Skipping...")
				end,
			}
		end
		
		--# call ready
		for moduleName: string, module: Module in self.modules do
			try {
				function()
					module:ready()
				end,
				function(err: string)
					console.warn(`{moduleName} ready callback failed`, `Err: {err}`, "Skipping...")
				end,
			}
		end
		
		if bootTimer then
			bootTimer:exit()
		end
		
		--console.log(`{game.RunService:IsServer() and "Server" or "Client"} booted in {os.clock() - startTimestamp}s`)
	end
} :: self