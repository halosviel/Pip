--[=[
	[INFO]
	author: @halosviel
	created: 2026 January 7
	
	[DESCRIPTION]
	Welds all BasePart descendants of instance to parent but not instance itself.
]=]

-- [REQUIRES]
local params = require("@game/ReplicatedFirst/pip/params")

-->

return function(instance: Instance, parent: BasePart)
	params.expect("Instance", instance)
	params.expect("BasePart", parent)
	
	for _, obj: Instance in instance:GetDescendants() do
		if not obj:IsA("BasePart") then
			continue
		end
		if obj == parent then
			continue
		end
		
		local weld: WeldConstraint = Instance.new("WeldConstraint")
		weld.Part0 = obj
		weld.Part1 = parent
		weld.Parent = parent
		
		obj.Anchored = false
	end
end