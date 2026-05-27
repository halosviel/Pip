--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Reads the player's preffered input from the preferredInput param
	or from UserInputService if there is none, and returns a stylised string.
	
	Used by kofetch
	
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
	if preferredInput then
		
	end
	
	local input: Enum.PreferredInput = preferredInput or game.UserInputService.PreferredInput
	return map[input] or "Unknown"
end