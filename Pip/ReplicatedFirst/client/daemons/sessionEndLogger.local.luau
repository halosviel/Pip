--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Prints the session duration at the end of a session.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local formatTime = require("@game/ReplicatedFirst/shared/utils/formatTime")

local startTimestamp = os.clock()

game.Players.PlayerRemoving:Connect(function(player: Player)
	if player ~= game.Players.LocalPlayer then
		return
	end
	
	console.log(`Session ended - Played for {formatTime(os.clock() - startTimestamp)}`)
end)