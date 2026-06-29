--[=[
	[INFO]
	author: @halosviel
	created: 2026 March 7
	
	[DESCRIPTION]
	Applies knockback and lift to the part in the direction of lookVector.
	
	[EXAMPLES]
	applyKnockback(part, Vector3.new(0, 0, 1), 25, 5)
	
	[UPDATES]
	2026 June 02: Made the module compatible with parts, not just players specifically.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")

-->

return function(part: Part, lookVector: Vector3, force: number, lift: number)
	--# dont assert targetCharacter -> anything can happen at runtime!
	if typeof(part) ~= "Instance" or typeof(part) == "Instance" and not part:IsA("BasePart") then
		console.warn("Request to apply knockback dropped: Invalid BasePart given")
		return
	end
	
	params.expect("Vector3", lookVector)
	params.expect("number", force)
	params.expect("number", lift)
	
	local velocity: Vector3 = (lookVector * force) + Vector3.new(0, lift, 0)
	
	local attachment = Instance.new("Attachment")
	attachment.Name = "KnockbackAttachment"
	attachment.Parent = part
	
	local linearVelocity = Instance.new("LinearVelocity")
	linearVelocity.Attachment0 = attachment
	linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	linearVelocity.VectorVelocity = velocity
	linearVelocity.MaxForce = math.huge
	linearVelocity.Parent = part
	
	game.Debris:AddItem(attachment, 0.15)
	game.Debris:AddItem(linearVelocity, 0.15)
	
	--console.log(`Knockback with {force} force applied to part "{tostring(part) or "Unknown"}"`)
end