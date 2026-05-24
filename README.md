# Pip

Pip is an open-sourced framework inspired by Linux and JavaScript.
It is built for personal use, but open to anyone who finds it :)

<p align="center">
    <img width="1280" height="720" alt="A screenshot showing what code using Pip would look like in a real project" src="https://github.com/user-attachments/assets/6626b1d0-56c7-41e3-a145-d1a3b996a67f" />
    <small>A project using Pip</small>
</p>

## About
Pip features an Arch-style output, a JS-like writing style, and a singleton module architecture.

The framework aims to be small yet highly customisable. It does not provide entire re-usable systems.
Instead, it comes with a predefined folder structure paired with in-house util modules that standardise workflow.

A typical project will consist of services and daemons. A template for services is provided in the server modules.
Daemons are Scripts/LocalScripts that run small, dedicated tasks akin to embedded devices. Examples include camera
bobbing and day cycles. 

Pip is meant to be build on top of - Each game the framework is used on is meant to be different in its own way,
but still retain the core structure and principles of the framework.

## Sample service
Also located in the `server/services`.
```lua
--[=[
	[INFO]
	author: @halosviel
	created: 2026 May 22
	
	[DESCRIPTION]
	
	[NOTES]
	- 
]=]

-- [REQUIRES]

-- [TYPES]
type self = {
	-- [CONFIG]
	
	-- [ENTRIES]
	
	-- [FUNCTIONS]
	constructor: ( self: self ) -> nil,
	ready: ( self: self ) -> nil
}
export type MyService = self

-->

return {
	constructor = function(self: self)
		-- CONFIG]
        
        -->
        
	end,
	
	ready = function(self: self)
		
	end,
} :: self
```

## Installation
Model: https://create.roblox.com/store/asset/113097113661715
<img width="277" height="418" alt="2026-05-24-184658_hyprshot" src="https://github.com/user-attachments/assets/5c199d4e-20ae-473d-8e44-a486c917b80b" />
