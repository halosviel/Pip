--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 21
	
	[DESCRIPTION]
	Prints client information like Linux's "neofetch" and "fastfetch" packages.
	
	[NOTES]
	- You must make your own function/field for any additions.
	- Should only be called once.
]=]

-- [CONFIG]
local message = ([[session started
		
 ____ ____ ____ 
||p |||i |||p ||
||__|||__|||__||
|/__\|/__\|/__\|

👤 %s@%s
┌──────────────────────────┐
   Game Version: %s
   Network: %s
   Input: %s
   Locale: %s
└──────────────────────────┘
]])

-- [REQUIRES]
local gameVersion = require("@game/ReplicatedFirst/shared/version")

-->

local function getNetworkStatus() : string
	local ping = math.floor(game.Players.LocalPlayer:GetNetworkPing() or 9 * 1000)
	local map = {
		{ 10, "Exceptional" },
		{ 50, "Good" },
		{ 100, "Alright" }
	}
	
	for i = 1, #map do
		local set = map[i]
		if ping < set[1] then
			return set[2]
		end
	end
	
	return "Bad"
end

local function getInput() : string
	local input: Enum.PreferredInput = game.UserInputService.PreferredInput
	local map = {
		[Enum.PreferredInput.Touch] = "Touch",
		[Enum.PreferredInput.Gamepad] = "Controller",
		[Enum.PreferredInput.KeyboardAndMouse] = "Keyboard/Mouse",
	}
	return map[input] or "Unknown"
end

local function getLocale() : string
	return game.LocalizationService.RobloxLocaleId or "Unknown"
end

return function()
	print(
		message:format(
			game.Players.LocalPlayer.DisplayName, game.Players.LocalPlayer.Name,
			gameVersion,
			getNetworkStatus(),
			getInput(),
			getLocale()
		)
	)
end