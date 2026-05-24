--[[


-- [ABOUT]

Pip is an open-sourced framework inspired by Linux and JavaScript.
It is built for personal use, but open to anyone who finds it :)

model: https://create.roblox.com/store/asset/113097113661715
repository: https://github.com/halosviel/Pip



-- [FEATURES]

It features an Arch-style output, a JS-like writing style, and a singleton module architecture.

The framework aims to be small yet highly customisable. It does not provide entire re-usable systems.
Instead, it comes with a predefined folder structure paired with in-house util modules that standardise workflow.

A typical project will consist of services and daemons. A template for services is provided in the server modules.
Daemons are Scripts/LocalScripts that run small, dedicated tasks akin to embedded devices. Examples include camera
bobbing and day cycles. 

Pip is meant to be build on top of - Each game the framework is used on is meant to be different in its own way,
but still retain the core structure and principles of the framework.



-->

[DETAILS]
- The commenting style mimics the style of microsoft ini files.

- Variable types are not explicitly defined unless necessary or unless the variable and its value are ambiguous.

- Defaults and fallbacks for variable outputs will usually be "??" or "Unknown".

- Configs of non-service scripts should be done at the top of the script, otherwise inside of the service's
  constructor function.



]]