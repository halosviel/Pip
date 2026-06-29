--[=[
	[INFO]
	author: @halosviel
	created: 2026 March 24
	
	[DESCRIPTION]
	A module that makes configuring audio much easier and removes repetition
	that would otherwise be predominant in manual sound management.
	
	Works by caching all Sounds in SoundService on runtime, then indexing them
	when needed.
	
	[EXAMPLE]
	SoundUtils.wrap("SomeSound")
		:clone()
		:autoDestroy()
		:setParent(workspace.static.Spawn)
		:play()
	
	[NOTES] 
	- No sound name duplicates are allowed whatsoever.
	- All chainable functions on an object should only be used once.
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")
local try =  require("@game/ReplicatedFirst/pip/try")

local maid = require("@game/ReplicatedFirst/shared/libs/maid")

-- [TYPES]
type self = {

	getSound: ( self: self ) -> Sound,
	playSound: ( self: self ) -> nil,

	-->

	instance: Sound,
	onDestroyCallbacks: { () -> nil },
	maid: maid.Maid,

	wrap: ( query: string | Instance ) -> self,
	get: ( self: self, ( sound: Sound ) -> nil ) -> self,
	clone: ( self: self ) -> self,
	setParent: ( self: self, parent: BasePart ) -> self,
	setVolume: ( self: self, volume: number ) -> self,
	onDestroy: ( self: self, callback: () -> nil ) -> self,

	setRandomPitch: ( self: self, value: number ) -> self,
	setRandomPitchRange: ( self: self, min: number, max: number ) -> self,
	setLifetime: ( self: self, value: number ) -> self,
	autoDestroy: ( self: self ) -> self,

	play: ( self: self ) -> self,
	stop: ( self: self ) -> self,

	Destroy: ( self: self ) -> nil
}
export type Sound = self

-->

--# Cache & preload

if game:GetService("RunService"):IsClient() then
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
end

local cacheStartTimestamp = os.clock()

local soundCache: { [string]: Sound } = {}
local conflicts: { string } = {}

local sounds: { Sound } = {}
local soundCount = 0

for _, sound: Sound in game.SoundService:GetDescendants() do
	if not sound:IsA("Sound") then
		continue
	end

	soundCount += 1
	
	local soundName = sound.Name
	if soundCache[soundName] then
		table.insert(conflicts, soundName)
		continue
	end
	
	table.insert(sounds, sound)
	soundCache[soundName] = sound
end

local cacheTotalDuration = os.clock() - cacheStartTimestamp
local conflictSuffix: string = #conflicts == 1 and "" or "s"
--console.log(`Cached {soundCount} sounds in {cacheTotalDuration}s ({#conflicts} conflict{conflictSuffix})`)

if #conflicts > 0 then
	console.log(`Cache conflicts: {table.concat(conflicts, ", ")}`)
end

task.spawn(function()
	try {
		function()
			local preloadingStartTimestamp = os.clock()
			game.ContentProvider:PreloadAsync(sounds)
		end,
		function(err: string)
			console.warn(`Preloading failed: {err}`)
		end,
	}
end)

-->

--# SoundService functions

local SoundUtils = {} :: self

--[[
	Get a sound in SoundService.
]]
function SoundUtils.getSound(soundName: string) : Sound
	params.expect("string", soundName)
	
	local index: Sound? = soundCache[soundName]
	if not index then
		console.error(`Sound "{soundName}" not found in cache`)
		return
	end
	
	return index
end

--[[
	Play a sound from SoundService.
]]
function SoundUtils.playSound(soundName: string)
	SoundUtils.getSound(soundName):Play()
end

-->

--# Class functions

--[[
	Takes a sound name or a sound instance and turns it into a class.
	If a string is passed, it will index the soundCache to find the sound.
	If a Sound instance is passed, it will use it directly.
]]
function SoundUtils.wrap(query: string | Instance) : self
	params.expectAny({"string", "Sound"}, query)
	
	local self = setmetatable({
		instance = typeof(query) == "Instance" and query or SoundUtils.getSound(query),
		onDestroyCallbacks = {},
		maid = maid.new()
	}, SoundUtils :: self)

	local sound: Sound = self.instance
	self.maid:GiveTask(sound.AncestryChanged:Connect(function(_: Instance, parent: Instance)
		if parent == nil then
			self:Destroy()
		end
	end))
	self.maid:GiveTask(sound.Destroying:Connect(function()
		self:Destroy()
	end))
	
	return self
end

--[[
	Calls the callback, passing self.instance as a parameter.
]]
function SoundUtils:get(callback: ( sound: Sound ) -> nil) : self
	params.expect("function", callback)
	callback(self.instance)
	return self
end

--[[
	Reassigns self.instance as its clone.
]]
function SoundUtils:clone() : self
	self.instance = self.instance:Clone()
	return self
end

function SoundUtils:setParent(parent: BasePart) : self
	params.expect("Instance", parent)
	self.instance.Parent = parent
	return self
end

function SoundUtils:setVolume(volume: number) : self
	params.expect("number", volume)
	self.instance.Volume = volume
	return self
end

--[[
	Adds a callback to be called when Destroy() is called or when the sound
	is destroyed.
]]
function SoundUtils:onDestroy(callback: () -> nil) : self
	params.expect("function", callback)
	table.insert(self.onDestroyCallbacks, callback)
	return self
end

--[[
	If attached, the sound and object will destroy after playing once.
	NOTE: Does not support looped audios.
]]
function SoundUtils:autoDestroy() : self
	self.instance.Ended:Once(function()
		self:Destroy()
	end)
	return self
end

--[[
	Assigns a random PlaybackSpeed from the range constructed from the value given.
]]
function SoundUtils:setRandomPitch(value: number) : self
	params.expect("number", value)
	self.instance.PlaybackSpeed += math.random(-value * 100, value * 100) / 100
	return self
end

--[[
	Assigns a random PlaybackSpeed from the range constructed from the range given.
]]
function SoundUtils:setRandomPitchRange(min: number, max: number) : self
	params.expect("number", min)
	params.expect("number", max)
	self.instance.PlaybackSpeed += math.random(-min * 100, max * 100) / 100
	return self
end

--[[
	Adds the sound to the Debris service with the lifetime being the value given.
]]
function SoundUtils:setLifetime(value: number) : self
	params.expect("number", value)
	game.Debris:AddItem(self.instance, value)
	return self
end

function SoundUtils:play() : self
	self.instance:Play()
	return self
end

function SoundUtils:stop() : self
	self.instance:Stop()
	return self
end

function SoundUtils:Destroy()
	pcall(function()
		self.instance:Destroy()
	end)
	
	if self.maid then
		self.maid:DoCleaning()
		self.maid = nil
	end
	
	for _, callback: () -> nil in self.onDestroyCallbacks do
		callback()
	end
	table.clear(self.onDestroyCallbacks)
	
	setmetatable(self, nil)
	table.clear(self)
end

SoundUtils.__index = SoundUtils
return SoundUtils