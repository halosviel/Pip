--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Listens to PreferredInput and prints its stylised string when it changes.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local getPreferredInputStyled = require("@game/ReplicatedFirst/shared/utils/getPreferredInputStyled")

-->

game.UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function(preferredInput: Enum.PreferredInput)
	local styledPreferredInput = getPreferredInputStyled(preferredInput)
	console.log(`Preferred input type changed to "{styledPreferredInput}"`)
end)