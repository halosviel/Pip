--[[

[CHANGELOGS]

--# 2026
JUNE 29: Updated console to hardcode params source.
JUNE 29: Added alias `devErr` to console.
JUNE 29: Added server assets folder.
JUNE 29: Updated main gui.
JUNE 29: Updated dataTemplate.
JUNE 29: Commented out boot time log.
JUNE 29: Updated the version module.
JUNE 29: Cleaned up kofetch.

JUNE 28: Updated server & client session scripts + renamed to "index".

JUNE 04: Updated boot error message formatting.

JUNE 02: Removed service preloading from boot. Instead, maintain standard: "If service is not in explorer, use GetService()".
JUNE 02: Updated applyKnockback to take BaseParts instead of characters.
JUNE 02: Added game service preloading to boot.

MAY 31: Added the assets folder to ReplicatedFirst.
MAY 31: Fixed SoundUtils yielding on the server.
MAY 31: Updated message in boot.
MAY 31: Updated message in processTimer.

MAY 28: Fixed an issue in StateMachine where it would display "err" instead of the actual error.

MAY 27: Updated console deverr message.
MAY 27: Updated StateMachine util.
MAY 27: Updated the inputChangeLogger daemon.
MAY 27: Removed getPreferredInputStyled module.
MAY 27: Updated most utils.

MAY 26: Updated try to validate the error handler on the initial call.
MAY 26: Removed redundant try statement checks in boot.

MAY 24: Updated README file; Will add a custom one to GitHub instead of using it.
MAY 24: Updated boot failure logs to be more legible + use new formatting.
MAY 24: Added function "deverr" to console.
MAY 24: Updated serviceTemplate, interfaceService, and added a comment in boot.

MAY 23: Revamp.
MAY 23: Enabled cript Sync to VSC + All libs.

MAY 17: Removed expectValue(), expectInArray(), & expectInDict() from params x.x
MAY 17: Added method expectValue() to params + minor improvements.
MAY 17: Added methods expectInArray() & expectInDict() to params.
MAY 17: constructor() and ready() are now called as methods, not functions.
MAY 17: Swapped RenderStepped to Heartbeat in kernel - Server cannot access.

]]