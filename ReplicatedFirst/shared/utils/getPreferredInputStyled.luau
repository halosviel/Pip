--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Reads the player's preffered input from the preferredInput param
	or from UserInputService if there is none, and returns a stylised string.
	
	[EXAMPLES]
	(1) getPreferredInputStyled() --> "Keyboard/Mouse"
	(2) getPreferredInputStyled(Enum.PreferredInput.Touch) --> "Touch"
]=]

local map = {
	[Enum.PreferredInput.Touch] = "Touch",
	[Enum.PreferredInput.Gamepad] = "Controller",
	[Enum.PreferredInput.KeyboardAndMouse] = "Keyboard/Mouse",
}

return function(preferredInput: Enum.PreferredInput?) : string
	local input: Enum.PreferredInput = game.UserInputService.PreferredInput
	return map[input] or "Unknown"
end