--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 12
	
	[DESCRIPTION]
	Contains essential functions of the framework, currently primarily
	the module loader.
	
	[NOTES]
	- There is no guard for same-name modules.
	- Shallow search is used for the services folder.
]=]

--# Configs
local LOGO_ENBALED = true
local LOGO = [[ Powered by

 ____ ____ ____ 
||p |||i |||p ||
||__|||__|||__||
|/__\|/__\|/__\|
]]
local LONG_BOOT = 10

--# Requires
local try = require("./try")
local console = require("./console")
local params = require("./params")

--# Types
type Module = {
	constructor: () -> nil,
	ready: () -> nil
}

-->

return {
	printLogo = function()
		if LOGO_ENBALED then
			print(LOGO)
		end
	end,
	
	boot = function(services: Folder) 
		console.log("Starting boot process...")
		params.expect("Folder", services)
		
		local moduleScripts: { ModuleScript } = services:GetChildren()
		if #moduleScripts == 0 then
			console.warn("Services folder is empty")
			console.log("==> Ending boot process")
			return
		end
		
		local startTimestamp = os.clock()
		local watcherThread
		
		watcherThread = game.RunService.RenderStepped:Connect(function()
			if os.clock() - startTimestamp >= LONG_BOOT then
				watcherThread:Disconnect()
				watcherThread = nil
				
				console.warn("BOOT :: Boot taking longer than usual")
				console.warn(`BOOT :: {LONG_BOOT}s elapsed`)
			end
		end)
		
		local modules: { Module } = {}
		for _, moduleScript: ModuleScript in moduleScripts do
			if not moduleScript:IsA("ModuleScript") then
				continue
			end
			local moduleName = moduleScript.Name
			
			local module: Module
			local moduleRequired = try {
				function()
					module = require(moduleScript)
				end,
				function(err: string)
					console.warn(`Failed to require {moduleName}: {err}`)
					console.warn(`Skipped {moduleName}`)
				end,
			}
			if not moduleRequired then
				continue
			end
			
			params.expect("table", module)
			params.expect("function", module.constructor)
			params.expect("function", module.ready)
			
			--# register
			modules[moduleName] = module
			
			--# call constructor
			local startTimestamp = os.clock()
			local constructorCalled = try {
				function()
					module.constructor()
				end,
				function(err: string)
					console.warn(`{moduleName} constructor() err: {err}`)
					console.warn(`Skipped {moduleName}`)
				end,
			}
			if not constructorCalled then
				continue
			end
			
			console.log(`==> Constructed {moduleName} in {os.clock() - startTimestamp}s`)
		end
		
		--# call ready
		for moduleName: string, module: Module in modules do
			local startTimestamp = os.clock()
			local readyCalled = try {
				function()
					module.ready()
				end,
				function(err: string)
					console.warn(`{moduleName} ready() err: {err}`)
					console.warn(`Skipped {moduleName}`)
				end,
			}
			
			if not readyCalled then
				continue
			end
			
			console.log(`==> Started {moduleName} in {os.clock() - startTimestamp}s`)
		end
		
		if watcherThread then
			watcherThread:Disconnect()
			watcherThread = nil
		end
		
		console.log(`==> All modules loaded in {os.clock() - startTimestamp}`)
		console.log("Ending boot process")
	end,
}
