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
		
	end,
	
	ready = function(self: self)
		local startTimestamp = os.clock()
		
		local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		local main: typeof(game.StarterGui.main) = playerGui:WaitForChild("main")
		
	end,
} :: self