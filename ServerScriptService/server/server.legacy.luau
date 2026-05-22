--[=[
	@halosviel | 2026 May 14
]=]

-- [CONFIGS]
local USE_SYSTEM_TIME = false

-- [REQUIRES]
local boot = require("@game/ReplicatedFirst/pip/boot")
local console = require("@game/ReplicatedFirst/pip/console")
local formatTime = require("@game/ReplicatedFirst/shared/utils/formatTime")

-->

local services = game.ServerScriptService.server.services
local startTimestamp = os.clock()
boot(services)

--# session wrapper
game:BindToClose(function()
	console.log(`SERVER :: Wrapping server - Ran for {formatTime(os.clock() - startTimestamp)} `)
end)