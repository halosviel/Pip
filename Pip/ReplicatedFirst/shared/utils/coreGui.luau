--[=[
	[INFO]
	author: @halosviel
	created: 2025 August 29
	
	[DESCRIPTION]
	Wrapper for enabling/disabling CoreGui features.
	
	[EXAMPLES]
	(1) coreGui:setResetEnabled(true)
	(2) coreGui:setLeaderboardEnabled(true)
	(3) coreGui:setChatEnabled(false)
	(4) coreGui:setAllEnabled(false)
	
	[NOTES]
	- State checking is not implemented, meaning that duplicate calls will still
	  go through. This should be harmless in practice though, just make sure to
	  properly manage all requests.
]=]

-- [REQUIRES]
local params = require("@game/ReplicatedFirst/pip/params")

-- [TYPES]
type self = {
	setResetEnabled: ( self: self, enabled: boolean ) -> nil,
	setLeaderboardEnabled: ( self: self, enabled: boolean ) -> nil,
	setChatEnabled: ( self: self, enabled: boolean ) -> nil,
	setAllEnabled: ( self: self, enabled: boolean ) -> nil,
}
export type CoreGui = self

-->

return {
	--# since this runs asynchronously, race conditions can happen if multiple calls happen simultaneously.
	--# updated logic 2026 May 14
	setResetEnabled = function(self: self, enabled: boolean)
		params.expect("boolean", enabled)
		task.spawn(function()
			repeat task.wait() until pcall(function()
				game.StarterGui:SetCore("ResetButtonCallback", false)
			end)
		end)
	end,
	
	setLeaderboardEnabled = function(self: self, enabled: boolean)
		params.expect("boolean", enabled)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, enabled)
	end,
	
	setChatEnabled = function(self: self, enabled: boolean)
		params.expect("boolean", enabled)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, enabled)
	end,
	
	setAllEnabled = function(self: self, enabled: boolean)
		params.expect("boolean", enabled)
		
		self:setResetEnabled(enabled)
		self:setLeaderboardEnabled(enabled)
		self:setChatEnabled(enabled)
	end,
} :: CoreGui