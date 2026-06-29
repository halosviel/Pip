--[=[
	[INFO]
	author: @halosviel
	created: 2026 February 25
	
	[DESCRIPTION]
	Simple state machine implementation.
	
	Has:
	- Sequential processing (queued states).
	- Set state from within a state.
	- Optional exit handler.
	
	[EXAMPLE]
	local stateMachine = require(script.Parent)
	
	local sm = stateMachine.new("MY_STATE_MACHINE", {
		intermission = {
			enter = function()
				
			end,
			exit = function() --# optional exit callback
				
			end,
		},
		
		round = {
			enter = function()
			
			end,
		}
	})
	
	sm:setState("intermission")
	task.wait(1)
	sm:setState("round")
	
	[NOTES]
	- Can't use self keyword as self in setState and Destroy due to module structure -> used "stateMachine" instead
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")
local try = require("@game/ReplicatedFirst/pip/try")

-- [TYPES]
type QueuedState = {
	stateName: string,
	args: { any? },
}

export type State = {
	enter: (( self: State, ...any) -> nil),
	exit: (( self: State ) -> nil)?,
}

type self = {
	name: string,
	state: string?,
	states: { [string]: State },
	queue: { QueuedState },
	locked: boolean,
	
	setState: ( self: self, stateName: string ) -> nil,
	Destroy: ( self: self ) -> nil,
}
export type StateMachine = self

-->

--# State machine runtime

local stateMachines: { self } = {}
local con: RBXScriptConnection?

--[[
	Stops the main heartbeat loop.
	Called when there are no more running state machines/when the last
	registered state machine is destroyed.
]]
local function stop()
	if con then
		con:Disconnect()
		con = nil
	end
end

--[[
	Starts the main heartbeat loop.
]]
local function start()
	con = game.RunService.Heartbeat:Connect(function()
		if #stateMachines == 0 then
			return
		end
		
		for _, stateMachine: self in stateMachines do
			
			--# get next state
			local queuedState: QueuedState = stateMachine.queue[1]
			if not queuedState then
				continue
			end
			
			table.remove(stateMachine.queue, 1)
			
			--# exit current state
			local currentStateName: string = stateMachine.state or "??"
			local currentState: State = stateMachine.states[currentStateName]
			
			if currentState and currentState.exit then
				try {
					function()
						currentState:exit()
					end,
					function(err: string)
						console.warn(`"{currentStateName}" exit state failed`, `Err: {err}`, `State machine: {stateMachine.name}`)
					end,
				}
			end
			
			--# enter new state
			if stateMachine.locked then
				stateMachine.locked = false
			end
			
			--# update state
			stateMachine.state = queuedState.stateName

			local nextStateName: string = queuedState.stateName or "??"
			local nextState: State = stateMachine.states[nextStateName]
			
			try {
				function()
					nextState:enter(table.unpack(queuedState.args))
				end,
				function(err: string)
					console.warn(`"{nextStateName}" enter state failed`, `Err: {err}`, `State machine: {stateMachine.name}`)
				end,
			}
			
			--# log
			--console.log(`Updated state machine "{stateMachine.name}" | {currentStateName} -> {nextStateName}`)
		end
	end)
end

local function isRunning() : boolean
	return con ~= nil
end

-->

--// State Machine

local StateMachine = {}

function StateMachine.new(name: string, states: { name: string, [string]: State? }) : self
	params.expect("string", name)
	params.expect("table", states)
	
	local stateNames: { string } = {}
	local noStates = true --# flag to replace #states since its a dict
	
	for stateName: string?, state: State? in states do
		params.expect("string", stateName) --# all keys should be a string (state name)
		params.expect("table", state) --# all states should be a dictionary
		
		local enterCallback: ((...any) -> nil)? = state.enter
		if not enterCallback then
			console.deverr("Cannot have a state without an enter callback", `State machine: {name}`)
		end
		
		local exitCallback: (() -> nil)? = state.exit
		if exitCallback then
			params.expect("function", exitCallback) --# exit should be a function
		end
		
		table.insert(stateNames, stateName)
		noStates = false
	end
	
	if noStates then
		console.deverr("Cannot have a state machine with no states", `State machine: {name}`)
	end
	
	local self = setmetatable({
		name = name,
		state = nil,
		states = states,
		queue = {},
		locked = false
	}, StateMachine :: StateMachine)
	
	table.insert(stateMachines, self)
	--console.log(`Created stateMachine {name}`, States: {table.concat(stateNames, ", ")})
	
	return self
end

function StateMachine:setState(stateName: string, ...: any)
	params.expect("string", stateName)
	
	local isValidState: boolean = false
	for key: string, _ in self.states do
		if key == stateName then
			isValidState = true
			break
		end
	end
	
	if isValidState == false then
		console.deverr(`"{stateName}" is not a valid state`, `State machine: {self.name}`)
		return
	end
	
	if self.state == stateName then
		return
	end
	
	if self.locked then
		return
	end
	
	--# add state to queue
	
	self.locked = true
	
	table.insert(self.queue, {
		stateName = stateName,
		args = {...},
	} :: QueuedState)
	
	if not isRunning() then
		start()
	end
end

function StateMachine:Destroy()
	--# 2026 May 29 hotfix
	if self.state then
		local currentState = self.states[self.state]
		if currentState and currentState.exit then
			try {
				function()
					currentState:exit()
				end,
				function(err)
					console.warn(`"{self.state}" exit failed during Destroy`, err)
				end,
			}
		end
	end
	-->
	
	table.remove(stateMachines, table.find(stateMachines, self))
	
	if isRunning() and #stateMachines == 0 then
		stop()
	end

	self.state = nil
	
	table.clear(self.states)
	self.states = nil
	
	table.clear(self.queue)
	self.queue = nil

	setmetatable(self, nil)
	table.clear(self)
end

StateMachine.__index = StateMachine
return StateMachine