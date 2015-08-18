function item_protective_wallon_spell_start(keys)	

	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local caster_team = caster:GetTeamNumber()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = 1

	-- Cosmetic variables
	local dummy_modifier = keys.dummy_modifier
	local wall_particle = keys.wall_particle
	local dummy_sound = keys.dummy_sound

	-- Ability variables
	local length = ability:GetLevelSpecialValueFor("length", ability_level) 
	local width = ability:GetLevelSpecialValueFor("width", ability_level)
	local duration = 7 or ability:GetLevelSpecialValueFor("duration", ability_level)

	-- Targeting variables
	local direction = (target_point - caster_location):Normalized()
	local rotation_point = target_point + direction * length/2
	local end_point_left = RotatePosition(target_point, QAngle(0,90,0), rotation_point)
	local end_point_right = RotatePosition(target_point, QAngle(0,-90,0), rotation_point)

	local direction_left = (end_point_left - target_point):Normalized() 
	local direction_right = (end_point_right - target_point):Normalized()

	-- Calculate the number of secondary dummies that we need to create
	local num_of_dummies = (((length/2) - width) / (width*2))
	if num_of_dummies%2 ~= 0 then
		-- If its an uneven number then make the number even
		num_of_dummies = num_of_dummies + 1
	end
	num_of_dummies = num_of_dummies / 2

	-- Create the main wall dummy
	local dummy = CreateUnitByName("npc_dummy_blank", target_point, false, caster, caster, caster_team)
	ability:ApplyDataDrivenModifier(dummy, dummy, dummy_modifier, {})
	EmitSoundOn(dummy_sound, dummy)	

	-- Create the secondary dummies for the left half of the wall
	for i=1,num_of_dummies + 2 do
		-- Create a dummy on every interval point to fill the whole wall
		local temporary_point = target_point + (width * 2 * i + (width - width/10)) * direction_left

		-- Create the secondary dummy and apply the dummy aura to it, make sure the caster of the aura is the main dummmy
		-- otherwise you wont be able to save illusion targets
		local dummy_secondary = CreateUnitByName("npc_dummy_blank", temporary_point, false, caster, caster, caster_team)
		ability:ApplyDataDrivenModifier(dummy, dummy_secondary, dummy_modifier, {})

		Timers:CreateTimer(duration, function()
			dummy_secondary:RemoveSelf()
		end)
	end

	-- Create the secondary dummies for the right half of the wall
	for i=1,num_of_dummies + 2 do
		-- Create a dummy on every interval point to fill the whole wall
		local temporary_point = target_point + (width * 2 * i + (width - width/10)) * direction_right
		
		-- Create the secondary dummy and apply the dummy aura to it, make sure the caster of the aura is the main dummmy
		-- otherwise you wont be able to save illusion targets
		local dummy_secondary = CreateUnitByName("npc_dummy_blank", temporary_point, false, caster, caster, caster_team)
		ability:ApplyDataDrivenModifier(dummy, dummy_secondary, dummy_modifier, {})

		Timers:CreateTimer(duration, function()
			dummy_secondary:RemoveSelf()
		end)
	end

	-- Create the wall particle
	local particle = ParticleManager:CreateParticle(wall_particle, PATTACH_POINT_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle, 0, end_point_left) 
	ParticleManager:SetParticleControl(particle, 1, end_point_right)

	-- Set a timer to kill the sound and particle
	Timers:CreateTimer(duration,function()
		StopSoundOn(dummy_sound, dummy)
		dummy:RemoveSelf()
	end)
end