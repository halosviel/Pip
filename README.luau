--[[

[README]
Pip is a framework inspired by Linux architecture and JavaScript syntax. It features a linux-style output and a JS-like writing style.

Pip operates on the fail fast principle - Errors that can be handled are always handled, and unexpected errors
that appear must be dealt with on a case-by case basis.

[DETAILS]
- Variable types are not explicitly defined unless necessary or unless the variable and its value are ambiguous.

- Defaults and fallbacks for variable output will usually be "??" or "Unknown".

- Configs of non-service scripts should be done at the top of the script, otherwise inside of the service's
  constructor function.
  
- The commenting style closely resembles the style of microsoft ini files.

]]