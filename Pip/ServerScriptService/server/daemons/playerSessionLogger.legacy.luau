--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Logs when players join and leave.
	
	Maintains its own player count instead of relying on the size
	of GetPlayers() because it is sometimes inaccurate when reading
	the value from PlayerRemoving.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")

-->

local playerCount = 0

local function getPlayerCount()
	return `{playerCount} player{playerCount == 1 and "" or "s"}`
end

game.Players.PlayerAdded:Connect(function(player: Player)
	playerCount += 1
	console.log(`{tostring(player)} joined ({getPlayerCount()})`)
end)

game.Players.PlayerRemoving:Connect(function(player: Player)
	playerCount -= 1
	console.log(`{tostring(player)} left ({getPlayerCount()})`)
end)