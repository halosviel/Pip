--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	A resyntaxed xpcall that copies JavaScript aesthetic.
	
	The first parameter is the main callback function that will be used in a
	pcall() operation, and the second the error handler that will be called in
	case the pcall fails.
	
	[EXAMPLES]
	try {
		function()
		
		end,
		function()
		
		end
	}
	
	[NOTES]
	- If the mainCallback returns nil, the parameter passed to the error
	  handler will be "??".
]=]

-- [REQUIRES]
local params = require("./params")

-->

return function(callbacks: { () -> nil }) : ( boolean, any )
	local mainCallback: () -> nil = callbacks[1]
	params.expect("function", mainCallback)
	
	local done, value: any = pcall(mainCallback)
	if done == false then
		local errorHandler: (() -> nil)? = callbacks[2]
		if errorHandler then
			params.expect("function", errorHandler)
			errorHandler(value or "??")
		end
	end
	
	return done, value
end