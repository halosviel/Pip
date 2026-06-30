--[=[
	@halosviel | 2026 May 16
]=]

-- [REQUIRES]
local types = require("./_types")

-- [TYPES]
type self = types.InterfaceService

-->

return {
	constructor = function(self: self)
		-- [ENTRIES]
		self.main = nil
	end,
	
	ready = function(self: self)
		local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		self.main = playerGui:WaitForChild("main")
		
	end,
} :: self