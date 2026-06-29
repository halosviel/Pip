--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	A centrallised custom logging module inspired from JavaScript that
	adds the script source and line.
	
	[NOTES]
	- Try to keep messages in one line.
	- If params are added, they will be added as tostringed lines under
	  the main messages, prefixed with "==> ". Reserve these lines for
	  details that could not be legibly fit into the main message.
	
	[EXAMPLES]
	console.log("hello world")
]=]

-- [CONFIGS]
local INFO_LEVEL = 3
local NIL_STR = "??"

-->
--# utils

local function getSource(message: string) : ( string, string )
	local path: string = debug.info(INFO_LEVEL, "s")
	
	local scriptName: string = path and path:match("[^%.]+$") or "Unknown"
	local result = scriptName:gsub("(%u)", " %1")
	scriptName = string.upper(result:gsub("^%s", ""))
	
	local line: number = debug.info(INFO_LEVEL, "l") or "0"
	return scriptName, line
end

--[[
	NOTE: The last parameter, n, is excluded
]]
local function formatTuple(...: any) : string
	local args: { any } = table.pack(...)
	if #args == 0 then
		return ""
	end
	
	local str = ""
	for i = 1, #args do
		local arg: any = args[i]
		str = str..`\n==> {tostring(arg)}`
	end
	
	return str
end

-->
--# main

local function _print(message: string, ...: any)
	print(message..formatTuple(...))
end

local function _warn(message: string, ...: any)
	local scriptName: string, line: string  = getSource()
	warn(`{scriptName} :: {message} - on line {line}`..formatTuple(...))
end

local function _error(message: string, ...: any)
	local scriptName: string, line: string  = getSource()
	error(`{scriptName} :: {message} - on line {line}`..formatTuple(...))
end

--# just appends "[DEVERR]" to the message
local function devError(message: string, ...: any)
	local scriptName: string, line: string  = getSource()
	error(`[DEV ERR] {scriptName} :: {message} - on line {line}`..formatTuple(...))
end

return {
	print = _print,
	warn = _warn,
	error = _error,
	deverror = devError,
	
	--# aliases
	log = _print,
	except = _error,
	deverr = devError
}