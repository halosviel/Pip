--[=[
	@halosviel | 2026 May 14
]=]

-- [REQUIRES]
local boot = require("@game/ReplicatedFirst/pip/boot")
local console = require("@game/ReplicatedFirst/pip/console")
local formatTime = require("@game/ReplicatedFirst/shared/utils/formatTime")

-->

local startTimestamp = os.clock()
boot:start(script.Parent.services)

--# session wrapper
game:BindToClose(function()
	console.log(`SERVER :: Wrapping server - Ran for {formatTime(os.clock() - startTimestamp)} `)
end)