--[=[
	[INFO]
	author: @halosviel
	created: 2026 June 29
	
	[DESCRIPTION]
	A module for services to require each other.
]=]

-- [REQUIRES]
local boot = require("@game/ReplicatedFirst/pip/boot")
local params = require("@game/ReplicatedFirst/pip/params")

-->

return function(path: string) : any
	params.expect("string", path)
	
	--# get caller script path via debug info
	local scriptName: string = debug.info(2, "s")
	
	--# split script path into args
	local indexes = string.split(scriptName, ".")
	
	--# get physical script by following path from game
	local caller: Instance = game
	for _, index in ipairs(indexes) do
		caller = caller:FindFirstChild(index)
	end
	
	--# same as above
	local instance: Instance = caller.Parent
	local _indexes = string.split(path, "/")
	
	for _, index in ipairs(_indexes) do
		if index == "" then
			continue
		elseif index == "@game" then
			instance = game
		elseif index == "." then
			instance = instance
		elseif index == ".." then
			instance = instance.Parent
		else
			instance = instance:FindFirstChild(index)
		end
		
		if instance == nil then
			params.expect("Instance", instance)
		end
	end
	
	params.expect("table", boot.modules[instance.Name])
	return boot.modules[instance.Name]
end 