--[=[
	[INFO]
	author: @halosviel
	created: 2026 February 20
	
	[DESCRIPTION]
	Takes a module template and turns it into OOP whilst preserving the
	framework syntax.
	
	Runs .new() & .ready() when a new class is created like Bootstrap.
	
	[EXAMPLES]
	return class {
		new = function()
		
		end,
		
		ready = function()
		
		end,
	}
	
	[NOTES]
	- Make sure to rename the constructor method & type to "new".
]=]

-- [REQUIRES]
local params = require("@game/ReplicatedFirst/pip/params")

return function(class) --# keep return type generic !!
	params.expect("table", class)
	params.expect("function", class.new)
	params.expect("function", class.ready)
	
	class.__index = class
	local original_new = class.new
	
	class.new = function(...)
		local self = setmetatable({}, class)
		if original_new then
			original_new(self, ...)
		end
		
		if class.ready then
			class.ready(self)
		end
		
		return self
	end
	
	return class
end