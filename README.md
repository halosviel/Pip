# Pip

Pip is an open-sourced framework inspired by Linux and JavaScript.
It is built for personal use, but open to anyone who finds it :)

<p align="center">
	<img width="1450" height="600" alt="A project using Pip" src="https://github.com/user-attachments/assets/dc564f86-17e9-4cf7-a3c8-082745a2d440" />
    <small>A project using Pip</small>
</p>

## Features
- Arch-linux style output
- JavaScript-like writing style
- Microsoft INI-inspired commenting syntax

## About
Pip aims to be small yet highly customisable. It does not provide entire re-usable systems.
Instead, it comes with a predefined folder structure and utility modules.

Pip is ran on what I call a service/daemon architecture.
- **Services** are systems (modules) that have multiple callers and purposes.
- **Daemons** are Scripts/LocalScripts that run background processes and small, dedicated tasks. Examples: Camera bobbing, day cycles.
A template for services is provided in the server modules folder.

Pip is meant to be build on top of - Each game the framework is used on is meant to be different in its own way, while still retaining the core structure and principles of the framework.

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

<img width="200" height="350" alt="Preview hierarchy of the Pip model" src="https://github.com/user-attachments/assets/878c36cb-4393-4d80-9997-a96b3477c2f5" />
