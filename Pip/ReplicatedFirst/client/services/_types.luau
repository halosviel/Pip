--[=[
	[INFO]
	author: @halosviel
	created: 2026 June 29
	
	[DESCRIPTION]
	Stores all client service types.
]=]

local stateMachine = require("@game/ReplicatedFirst/shared/utils/stateMachine")

export type InterfaceService = {
	clientService: ClientService,
	constructor: ( self: InterfaceService ) -> nil,
	enterMenu: ( self: InterfaceService ) -> nil,
	exitMenu: ( self: InterfaceService ) -> nil,
	ready: ( self: InterfaceService ) -> nil
}

export type ClientService = {
	interfaceService: InterfaceService,
	stateMachine: stateMachine.StateMachine,
	constructor: ( self: ClientService ) -> nil,
	ready: ( self: ClientService ) -> nil
}

return {}