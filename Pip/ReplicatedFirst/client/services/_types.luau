--[=[
	[INFO]
	author: @halosviel
]=]

export type InterfaceService = {
	main: typeof(game.StarterGui.main),
	constructor: ( self: InterfaceService ) -> nil,
	ready: ( self: InterfaceService ) -> nil
}

return {}