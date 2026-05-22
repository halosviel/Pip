--[=[
	@halosviel | 2026 May 16
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")

-- [TYPES]
type self = {
	constructor: ( self: self ) -> nil,
	ready: ( self: self ) -> nil
}
export type InterfaceService = self

-->

return {
	constructor = function(self: self)
	end,
	
	ready = function(self: self)
		local startTimestamp = os.clock()
		
		local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		local main: typeof(game.StarterGui.main) = playerGui:WaitForChild("main")
		
		--# cont...
	end,
} :: self