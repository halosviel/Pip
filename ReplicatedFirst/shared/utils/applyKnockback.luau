--[=[
	[INFO]
	author: @halosviel
	created: 2026 March 7
	
	[DESCRIPTION]
	Applies knockback to the target's HumanoidRootPart in the direction of lookVector.
	
	[EXAMPLES]
	applyKnockback(character, Vector3.new(0, 0, 1), 25, 5)
	
	[NOTES]
	- Works even if humanoid is dead.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")

-->

return function(targetCharacter: Model, lookVector: Vector3, force: number, lift: number)
	--# dont assert targetCharacter -> anything can happen at runtime!
	local targetCharacterType = typeof(targetCharacter)
	if targetCharacterType ~= "Instance" or targetCharacterType == "Instance" and targetCharacter.ClassName ~= "Model" then
		console.warn("Request to apply knockback dropped: Invalid target character")
		return
	end
	
	params.expect("Vector3", lookVector)
	params.expect("number", force)
	params.expect("number", lift)
	
	local targetRootPart: Part? = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not targetRootPart then
		console.warn("Request to apply knockback dropped: target character did not have a HumanoidRootPart")
		return
	end
	
	local velocity: Vector3 = (lookVector * force) + Vector3.new(0, lift, 0)
	
	local attachment = Instance.new("Attachment")
	attachment.Name = "KnockbackAttachment"
	attachment.Parent = targetRootPart
	
	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Attachment0 = attachment
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	linearVelocity.VectorVelocity = velocity
	linearVelocity.MaxForce = math.huge
	linearVelocity.Parent = targetRootPart
	
	game.Debris:AddItem(attachment, 0.15)
	game.Debris:AddItem(linearVelocity, 0.15)
	
	--console.log(`Knockback with {force} force applied to player {tostring(targetCharacter) or "Unknown"}`)
end