earth_arrow_lua = class({})
LinkLuaModifier( "modifier_earth_arrow_stun_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_arrow_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_arrow_thinker_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function earth_arrow_lua:OnSpellStart()
	print ("OnSpellStart")
	print(self:GetCursorPosition())
	
	self.mirana_arrow_width = self:GetSpecialValueFor( "arrow_width" )
	self.mirana_arrow_speed = self:GetSpecialValueFor( "arrow_speed" )
	self.mirana_arrow_distance = self:GetSpecialValueFor( "arrow_range" )
	self.mirana_arrow_vision = self:GetSpecialValueFor( "arrow_vision" )
	self.mirana_arrow_damage = self:GetSpecialValueFor( "arrow_damage" )
	self.mirana_arrow_max_stunrange = self:GetSpecialValueFor( "arrow_max_stunrange" )
	self.mirana_arrow_bonus_damage = self.mirana_arrow_damage * 0.2
	self.mirana_arrow_max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	self.mirana_arrow_min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
	
	
	self.earth_duration = self:GetSpecialValueFor( "earth_duration" )
	self.earth_slow = self:GetSpecialValueFor( "earth_slow" )
	self.earth_aoe = self:GetSpecialValueFor( "earth_aoe" )
	
	
	
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
end

function earth_arrow_lua:OnProjectileHit( hTarget, vLocation )
	print ("OnProjectileHit")
	
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		print (hTarget)
		
		EmitSoundOn( "Hero_Mirana.ArrowImpact", hTarget )
	
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
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_earth_arrow_stun_lua", { duration = stunduration } )
		
	end
	
	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_earth_arrow_thinker_lua", kv, vLocation, self:GetCaster():GetTeamNumber(), false )
	
	return true
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------