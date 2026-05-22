--[=[
	[INFO]
	author: @halosviel
	created: 2026 January 6
	
	[DESCRIPTION]
	A module with helpful tween utils.
	
	[EXAMPLES]
	(1) tweenService:Create(someTextLabel, tweenUtils.getPreset(1), { TextColor = Color3.fromRGB(255, 255, 255) }):Play()'
	(2)
	tweenUtils.tweenNumberSequence({
		script.Parent.UIGradient,
		"Transparency",
		TweenInfo.new(2),
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, 0),
			ColorSequenceKeypoint.new(1, 0)
		}),
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, 1),
			ColorSequenceKeypoint.new(1, 1)
		})
	}):Play()
]=]

-- [REQUIRES]
local console = require("@game/ReplicatedFirst/pip/console")
local params = require("@game/ReplicatedFirst/pip/params")

-- [TYPES]
type NumberSequenceData = {
	time: number,
	from: number,
	to: number
}

-->

--# tweenInfo cache
local presetsCache = {} :: { [number]: TweenInfo }

return {
	
	--[[
		Returns a new TweenInfo with my preferred EasingStyle & EasingDirection
		I use for most things, with the duration being what the parameter specified.
		
		Uses lazy loading for micro optimisation.
	]]
	getPreset = function(duration: number) : TweenInfo
		params.expect("number", duration)
		
		local index: TweenInfo? = presetsCache[duration]
		if index then
			return index
		end
		
		local newIndex: TweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		presetsCache[duration] = newIndex
		
		return newIndex
	end,
	
	--[[
		Tweens a number using NumberValues.
		
		tweenUtils.tweenNumber(0, 1, tweenInfo, function()
			print("tween number finished")
		end)
	]]
	tweenNumber = function(startValue: number, endValue: number, tweenInfo: TweenInfo, callback: (( value: number ) -> nil)?) : NumberValue
		params.expect("number", startValue)
		params.expect("number", endValue)
		params.expect("TweenInfo", tweenInfo)
		params.expect("function", callback)
		
		local newNumberValue: NumberValue = Instance.new("NumberValue")
		newNumberValue.Value = startValue
		
		local con: RBXScriptConnection?
		con = newNumberValue:GetPropertyChangedSignal("Value"):Connect(function()
			callback(newNumberValue.Value)
		end)

		newNumberValue.Destroying:Connect(function()
			if con then
				con:Disconnect()
				con = nil
			end
		end)
		
		local newTween: Tween = game.TweenService:Create(newNumberValue, tweenInfo, { Value = endValue })
		newTween:Play()
		newTween.Completed:Once(function()
			newNumberValue:Destroy()
		end)
		
		return newNumberValue
	end,
	
	--[[
		Tweens a NumberSequence type property of an instance.
		"from" and "to" must have the same keypoint time positions.
		
		clanker couldnt even do ts so i just had to do it myself
	]]
	tweenNumberSequence = function(instance: Instance, property: string, tweenInfo: TweenInfo, from: NumberSequence, to: NumberSequence) : Tween
		
		--# validations
		
		params.expect("Instance", instance)
		params.expect("string", property)
		
		if instance[property] == nil then
			console.warn(`Request to tween numseq dropped: {property} is not a valid property of {instance.ClassName}`)
			return
		end
		
		params.expect("TweenInfo", tweenInfo)
		params.expect("NumberSequence", from)
		params.expect("NumberSequence", to)
		
		local fromKeypoints = #from.Keypoints
		local toKeypoints = #to.Keypoints
		if fromKeypoints ~= toKeypoints then
			console.warn(`Request to tween numseq dropped: Keypoint amount mismatch | Got {#fromKeypoints} & {toKeypoints}`)
			return
		end
		
		-->
		
		local values = {} :: { NumberSequenceData }
		--# compare both numseqs to see if they have matching time positions
		--# cache them
		for _, keypoint: NumberSequenceKeypoint in from.Keypoints do
			local keypointRounded: number = math.floor(keypoint.Time * 10) / 10
			local matchFound: boolean = false --# time pos match check
			
			for _, _keypoint: NumberSequenceKeypoint in to.Keypoints do
				local _keypointRounded: number = math.floor(_keypoint.Time * 10) / 10
				if _keypointRounded == keypointRounded then
					matchFound = true
					
					table.insert(values, {
						time = keypoint.Time,
						from = keypoint.Value,
						to = _keypoint.Value
					} :: NumberSequenceData)
					continue
				end
			end
			assert(matchFound, `No match found for time {keypointRounded} in "to" NumberSequenceKeypoint`)
		end
		
		local numberValue: NumberValue = Instance.new("NumberValue")
		local connections: { RBXScriptConnection } = {}
		
		local tween: Tween = game.TweenService:Create(numberValue, tweenInfo, { Value = 1 })
		local function cleanup()
			for _, con: RBXScriptConnection in connections do
				con:Disconnect()
				con = nil
			end
			numberValue:Destroy()
		end
		
		table.insert(connections, tween.Completed:Once(cleanup))
		table.insert(connections, tween:GetPropertyChangedSignal("PlaybackState"):Connect(function()
			if tween.PlaybackState == Enum.PlaybackState.Playing then
				table.insert(connections, game.RunService.Heartbeat:Connect(function()
					local keypoints = {} :: { NumberSequenceKeypoint }
					
					for _, numberSequenceData: NumberSequenceData in values do
						table.insert(keypoints, NumberSequenceKeypoint.new(
							numberSequenceData.time,
							numberSequenceData.from + ( numberSequenceData.to - numberSequenceData.from ) * numberValue.Value)
						)
					end
					
					instance[property] = NumberSequence.new(keypoints)
				end))
			end
		end))
		
		return tween
	end
}