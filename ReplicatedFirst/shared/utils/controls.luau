--[=[
	[INFO]
	author: @halosviel
	created: 2025 December 16
	
	[DESCRIPTION]
	Wrapper for enabling/disabling character controls (most optimal way
	of toggling character movement).
	
	[EXAMPLES]
	(1) controls.enable()
	(2) controls.disable()
	
	[NOTES]
	- Works even if the player has no character (kudos roblox)! It will
	  emit a warn though.
]=]

-- [TYPES]
type Controls = { --# made by clanker
	inputMoveVector: Vector3,
	
	GetMoveVector: ( self: Controls ) -> Vector3,
	GetEstimatedVRTorsoFrame: ( self: Controls ) -> CFrame,
	GetActiveController: ( self: Controls ) -> any,
	UpdateActiveControlsEnabled: ( self: Controls ) -> (),
	Enable: ( self: Controls, enable: boolean? ) -> (),
	Disable: ( self: Controls ) -> (),
	SelectComputerMovementModule: ( self: Controls ) -> ( {}?, boolean ),
	SelectTouchModule: ( self: Controls ) -> ( {}?, boolean ),
	OnRenderStepped: ( self: Controls, dt: number ) -> (),
	OnHumanoidSeated: ( self: Controls, active: boolean, currentSeatPart: BasePart ) -> (),
	OnCharacterAdded: ( self: Controls, char: Model ) -> (),
	OnCharacterRemoving: ( self: Controls, char: Model ) -> (),
	UpdateTouchGuiVisibility: ( self: Controls ) -> (),
	SwitchToController: ( self: Controls, Controls: any ) -> (),
	UpdateMovementMode: ( self: Controls ) -> (),
	CreateTouchGuiContainer: ( self: Controls ) -> (),
	GetClickToMoveController: ( self: Controls ) -> any
}
--# screw typing
--# allat to use 2 properties x_x

-->

local playerModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local controls: Controls = playerModule:GetControls()

return {
	enable = function()
		controls:Enable()
	end,
	
	disable = function()
		controls:Disable()
	end,
}