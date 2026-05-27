# Pip

Pip is an open-sourced framework inspired by Linux and JavaScript.
It is built for personal use, but open to anyone who finds it :)

<p align="center">
	<img width="1450" height="600" alt="A project using Pip" src="https://github.com/user-attachments/assets/dc564f86-17e9-4cf7-a3c8-082745a2d440" />
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

## Service Template
Also located in `server/services`.
<details>
<summary>sampleService</summary>

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
		
	end,
	
	ready = function(self: self)
		
	end,
} :: self
```

</details>

## Installation
#### Model
https://create.roblox.com/store/asset/113097113661715

<img width="250" height="350" alt="Preview hierarchy of the Pip model" src="https://github.com/user-attachments/assets/878c36cb-4393-4d80-9997-a96b3477c2f5" />
