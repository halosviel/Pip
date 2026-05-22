--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Logs when players join and leave.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")

-->

local function getPlayerCount()
	local playerCount = #game.Players:GetPlayers()
	return `{playerCount} player{playerCount == 1 and "" or "s"}`
end

game.Players.PlayerAdded:Connect(function(player: Player)
	console.log(`{tostring(player)} joined ({getPlayerCount()})`)
end)

game.Players.PlayerRemoving:Connect(function(player: Player)
	console.log(`{tostring(player)} left ({getPlayerCount()})`)
end)