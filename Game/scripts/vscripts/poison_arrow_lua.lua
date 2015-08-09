--require( "timers" )

--------------------------------------------------------------------------------

poison_arrow_lua = class({})
LinkLuaModifier( "modifier_poison_arrow_stun_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_poison_arrow_tracer_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_poison_arrow_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function poison_arrow_lua:OnSpellStart()

	self.mirana_arrow_width = self:GetSpecialValueFor( "arrow_width" )
	self.mirana_arrow_speed = self:GetSpecialValueFor( "arrow_speed" )
	self.mirana_arrow_distance = self:GetSpecialValueFor( "arrow_range" )
	self.mirana_arrow_vision = self:GetSpecialValueFor( "arrow_vision" )
	self.mirana_arrow_damage = self:GetSpecialValueFor( "arrow_damage" )
	self.mirana_arrow_max_stunrange = self:GetSpecialValueFor( "arrow_max_stunrange" )
	self.mirana_arrow_bonus_damage = self.mirana_arrow_damage * 0.2
	self.mirana_arrow_max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	self.mirana_arrow_min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
		
	
	EmitSoundOn( "Hero_Mirana.ArrowCast", self:GetCaster() )
	
	local vTargetPosition = self:GetCursorPosition()
	vMirana_Arrow_CastPosition = self:GetCaster():GetOrigin()
	
	local vDirection = vTargetPosition - vMirana_Arrow_CastPosition
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	
	local info = {
		EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		Ability = self,
		vSpawnOrigin = vMirana_Arrow_CastPosition, 
		fStartRadius = self.mirana_arrow_width,
		fEndRadius = self.mirana_arrow_width,
		vVelocity = vDirection * self.mirana_arrow_speed,
		fDistance = self.mirana_arrow_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bHasFrontalCone = false,
		bProvidesVision = true,
		iVisionRadius = self.mirana_arrow_vision,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()
	}
	
	ProjectileManager:CreateLinearProjectile( info )

	-- Setting up the tracer variables
	local caster = self:GetCaster()

	caster.poison_arrow_traveling = true
	caster.poison_arrow_move_direction = vDirection
	caster.poison_arrow_place_position = caster:GetOrigin()
	caster.freg = 1/10
	caster.multiplier = 150 --self.mirana_arrow_speed / 4
	caster.poison_arrow_place_position = caster.poison_arrow_place_position + Vector(caster.poison_arrow_move_direction.x * caster.multiplier, caster.poison_arrow_move_direction.y * caster.multiplier, 0)

	Timers:CreateTimer(function()
		print ("TimerCreated")
		if caster.poison_arrow_traveling then
			-- Tracer dummy
			local caster = self:GetCaster()
			poison_tracer = CreateUnitByName("npc_dummy_blank", caster.poison_arrow_place_position, false, caster, caster, caster:GetTeam())
			
			poison_tracer:AddNewModifier( self:GetCaster(), self, "modifier_poison_arrow_tracer_lua", { duration = self:GetSpecialValueFor( "tail_lifetime" ) } )

			print("Poison created")
			
			caster.poison_arrow_place_position = caster.poison_arrow_place_position + Vector(caster.poison_arrow_move_direction.x * caster.freg * self.mirana_arrow_speed, caster.poison_arrow_move_direction.y * caster.freg * self.mirana_arrow_speed, 0)
			
			return caster.freg
		else
			return nil
		end

	end)	
end

function poison_arrow_lua:OnProjectileHit( hTarget, vLocation )
	
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		
		EmitSoundOn( "Hero_Mirana.ArrowImpact", hTarget )

		if hTarget:FindModifierByName("modifier_shield_of_luck") then
			if RandomInt(1, 100) <= hTarget:FindModifierByName("modifier_shield_of_luck"):GetAbility():GetSpecialValueFor("chance") then
				ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm_bolt_hero.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget )
				return true
			end
		end
	
		--distance calculations
		
		local vDistance = vLocation - vMirana_Arrow_CastPosition
		local fDistance = vDistance:Length2D()

		
		if fDistance > self.mirana_arrow_max_stunrange then
			fDistance = self.mirana_arrow_max_stunrange
		end

	
	
		--additional dmg & stun calculations
		
		local multiplier = fDistance / self.mirana_arrow_max_stunrange
		multiplier = math.floor(multiplier * 10) / 10

		
		local additionaldmg = math.floor(multiplier * self.mirana_arrow_bonus_damage)
	
		
		local stunduration = multiplier * self.mirana_arrow_max_stun
		if stunduration < self.mirana_arrow_min_stun then
			stunduration = self.mirana_arrow_min_stun
		end
		
	
	
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.mirana_arrow_damage + additionaldmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_poison_arrow_stun_lua", { duration = stunduration } )
		
	end
	

	caster = self:GetCaster()
	caster.poison_arrow_traveling = false

	return true
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------