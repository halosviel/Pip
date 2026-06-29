--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	Takes seconds and returns it in the format: 
	years -> months -> weeks -> days -> hours -> minutes -> seconds
	
	[EXAMPLES]
	(1) print(formatTime(1)) -> 1s
	(2) print(formatTime(12)) -> 12s
	(3) print(formatTime(123)) -> 2m 3s
	(4) print(formatTime(1234)) -> 20m 34s
	(5) print(formatTime(12345)) -> 3h 25m 45s
	(6) print(formatTime(123456)) -> 1d 10h 17m 36s
	(7) print(formatTime(12345678)) -> 4mo 3w 1d 21h 21m 18s
	(8) print(formatTime(123456789)) -> 3y 11mo 3d 21h 33m 9s
	
	[NOTES]
	- Calculations are as follows:
	    i. month = 30 days
	    ii. year = 365 days
	- clanker code!!
]=]

-- [REQUIRES]
local params = require("@game/ReplicatedFirst/pip/params")

-->

return function(seconds: number) : string
	params.expect("number", seconds)
	
	seconds = math.max(0, math.floor(seconds))
	
	local YEAR = 365 * 24 * 60 * 60
	local MONTH = 30 * 24 * 60 * 60
	local WEEK = 7 * 24 * 60 * 60
	local DAY = 24 * 60 * 60
	local HOUR = 60 * 60
	local MINUTE = 60
	
	local years = math.floor(seconds / YEAR)
	seconds = seconds % YEAR
	
	local months = math.floor(seconds / MONTH)
	seconds = seconds % MONTH
	
	local weeks = math.floor(seconds / WEEK)
	seconds = seconds % WEEK
	
	local days = math.floor(seconds / DAY)
	seconds = seconds % DAY
	
	local hours = math.floor(seconds / HOUR)
	seconds = seconds % HOUR
	
	local minutes = math.floor(seconds / MINUTE)
	seconds = seconds % MINUTE
	
	local parts = {}
	
	if years > 0 then table.insert(parts, years .. "y") end
	if months > 0 then table.insert(parts, months .. "mo") end
	if weeks > 0 then table.insert(parts, weeks .. "w") end
	if days > 0 then table.insert(parts, days .. "d") end
	
	if hours > 0 or #parts > 0 then
		table.insert(parts, hours .. "h")
	end
	
	if minutes > 0 or #parts > 0 then
		table.insert(parts, minutes .. "m")
	end
	
	table.insert(parts, seconds .. "s")
	
	return table.concat(parts, " ")
end