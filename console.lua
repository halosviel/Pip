--[=[a
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	A centrallised wrapper for print(), warn(), and error().
	Created for scalable customisation of the output string and behaviour.
	
	There are also aliases which can be used in place of some functions.
	
	[NOTES]
	- The Pip framework discourages multi-line and multi-parameter prints,
	  so no extra params (tuple) are added.
	
	[EXAMPLES]
	console.log("hello world")
]=]

--# Configs
local INFO_LEVEL = 2
local NIL_STR = "??"

-->

local function _error(message: string)
	error(`ERROR :: {message}`)
end

return {
	--# main
	print = print,
	warn = function(message: string)
		local path: string = debug.info(INFO_LEVEL, "s")
		local name: string = path and path:match("[^%.]+$") or "Unknown"
		local line: number = debug.info(INFO_LEVEL, "l") or "0"
		
		warn(`WARNING :: [{name}:{line}] {message}`)
	end,
	error = _error,
	
	--# aliases
	log = print,
	except = _error
}
