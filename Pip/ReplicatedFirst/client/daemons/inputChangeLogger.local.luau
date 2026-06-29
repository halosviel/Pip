--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Listens to PreferredInput and prints its stylised string when it changes.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")

-->

local map = {
	[Enum.PreferredInput.Touch] = "Touch",
	[Enum.PreferredInput.Gamepad] = "Controller",
	[Enum.PreferredInput.KeyboardAndMouse] = "Keyboard/Mouse",
}

local function getPreferredInputStyled(preferredInput: Enum.PreferredInput?) : string
	if preferredInput then
		params.expect("Enum", preferredInput)
	end
	
	local input: Enum.PreferredInput = preferredInput or game.UserInputService.PreferredInput
	local result: string = map[input] or "Unknown"
	
	return result
end

game.UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function(preferredInput: Enum.PreferredInput)
	local styledPreferredInput: string = getPreferredInputStyled(preferredInput)
	console.log(`Preferred input type changed to "{styledPreferredInput}"`)
end)