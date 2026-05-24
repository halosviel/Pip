--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	A handy util that replaces assert. Contains functions for parameter validation.
	If the conditions of a function are not met, it will throw an error and stop 
	the thread.
	
	"match" refers to both type and class collectively.
	
	[EXAMPLES]
	(1) params.expect("string", myVariable)
	(2) params.expect("MeshPart", myVariable)
	(3) params.expectAny({"string", "MeshPart"}, myVariable) -- can be either
	
	[NOTES]
	- [!] expect() does not check whether the match string is a valid type/classname
	  due to bleeding edge nature (not bothered to update for every new instance
	  added to the game). I trust you and I to know our types/classnames :D
	- Nil checks must be done manually; it cannot be done here.
	- really wish the stack trace of the error to be gone, but whatever at least
	  we have a clickable trace
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")

-->

local throwErr = function(match: string, param: string)
	console.deverr(`Param type mismatch ({match} expected, got {typeof(param) == "Instance" and param.ClassName or typeof(param)})`)
end

--[[
	Checks if the given match is the same type/class as param.
]]
local isMatch = function(match: string, param: string) : boolean
	return match == param
		or match == typeof(param)
		or (typeof(param) == "Instance"
			and type(match) == "string"
			and param:IsA(match))
end

return {
	expect = function(match: any, param: any)
		if not isMatch(match, param) then
			throwErr(match, param)
			return
		end
	end,
	
	--[[
		Works the same as expect, but takes an array where param is
		compared to each object in the array. Useful for when param
		can be multiple types.
	]]
	expectAny = function(matches: { any }, param: any)
		local matching = false
		for _, match in matches do
			if isMatch(match, param) then
				matching = true
				break
			end
		end
		
		if matching == false then
			throwErr(`any\{{table.concat(matches, ", ")}\}`, param)
			return
		end
	end
}