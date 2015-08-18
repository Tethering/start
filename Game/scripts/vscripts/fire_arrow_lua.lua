fire_arrow_lua = class({})
LinkLuaModifier( "modifier_fire_arrow_stun_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function fire_arrow_lua:OnSpellStart()
	UnitsUnderAttack = {}

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
	vMirana_Arrow_CasterPosition = self:GetCaster():GetOrigin()
	
	local vDirection = vTargetPosition - vMirana_Arrow_CasterPosition
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	
	local info = {
		EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		Ability = self,
		vSpawnOrigin = vMirana_Arrow_CasterPosition, 
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
	isArrow = true
end

function fire_arrow_lua:OnProjectileHit( hTarget, vLocation )
	if isArrow then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		

			EmitSoundOn( "Hero_Mirana.ArrowImpact", hTarget )


			if hTarget:FindModifierByName("modifier_shield_of_luck") then
				if RandomInt(1, 100) <= hTarget:FindModifierByName("modifier_shield_of_luck"):GetAbility():GetSpecialValueFor("chance") then
					ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_static_storm_bolt_hero.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget )
					return true
				end
			end


			--distance calculations
			
			local vDistance = vLocation - vMirana_Arrow_CasterPosition
			local fDistance = vDistance:Length2D()
			print (fDistance)
			
			if fDistance > self.mirana_arrow_max_stunrange then
				fDistance = self.mirana_arrow_max_stunrange
			end
			print (fDistance)
		
		
			--additional dmg & stun calculations
			
			local multiplier = fDistance / self.mirana_arrow_max_stunrange
			multiplier = math.floor(multiplier * 10) / 10
			print (multiplier)
			
			local additionaldmg = math.floor(multiplier * self.mirana_arrow_bonus_damage)
			print (additionaldmg)
			
			local stunduration = multiplier * self.mirana_arrow_max_stun
			if stunduration < self.mirana_arrow_min_stun then
				stunduration = self.mirana_arrow_min_stun
			end
			print (stunduration)
		
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.mirana_arrow_damage + additionaldmg,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )
			
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_fire_arrow_stun_lua", { duration = stunduration } )
		end

		isArrow = false
		
		local radius = self:GetSpecialValueFor("effect_radius")
		local speed = self:GetSpecialValueFor("effect_speed")
		local caster = self:GetCaster()
		local pos
		if target == nil then
			pos = vLocation
		else
			pos = target:GetOrigin()
		end

		EmitSoundOnLocationWithCaster(pos, "Hero_Lina.DragonSlave.Cast", self:GetCaster())
		--EmitSoundOn( "Hero_Lina.DragonSlave.Cast", target )

		local vDirection = RandomVector(1)
		vDirection.z = 0
		vDirection = vDirection:Normalized()

		local info = {
			EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
			Ability = self,
			vSpawnOrigin = pos, 
			fStartRadius = 0,
			fEndRadius = radius * 3.14 * 2 / 8,
			vVelocity = vDirection * speed,
			fDistance = radius,
			Source = caster,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}
		ProjectileManager:CreateLinearProjectile( info )

		for i = 1, 7 do
			info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,45 * i,0), vDirection):Normalized() * speed
			ProjectileManager:CreateLinearProjectile( info )
		end

		EmitSoundOnLocationWithCaster(pos, "Hero_Lina.DragonSlave", self:GetCaster())
		--EmitSoundOn( "Hero_Lina.DragonSlave", target )



		return true
	else

		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			for key, unit in pairs(UnitsUnderAttack) do
				print (key, unit)
				if hTarget == unit then
					return false
				end
			end

			table.insert(UnitsUnderAttack, hTarget)

			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetSpecialValueFor("effect_damage"),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )

			local vDirection = vLocation - self:GetCaster():GetOrigin()
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()
			
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
			ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		return false
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
