modifier_earth_arrow_thinker_lua = class({})

--------------------------------------------------------------------------------

function modifier_earth_arrow_thinker_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_thinker_lua:OnCreated( kv )	
	self.earth_aoe = self:GetAbility():GetSpecialValueFor("earth_aoe")
	self.earth_duration = self:GetAbility():GetSpecialValueFor("earth_duration")
	self.earth_slow = self:GetAbility():GetSpecialValueFor( "earth_slow" )
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.earth_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_earth_arrow_effect_lua", { duration = self.earth_duration } )
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.earth_aoe, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Brewmaster.ThunderClap", self:GetCaster() )



		--[[
		local dummi = CreateUnitByName("npc_dummy_blank", self:GetParent():GetOrigin(), false, self:GetCaster(), nil, self:GetCaster():GetTeamNumber())
		print (dummi)
		dummi:AddAbility("lycan_summon_wolves")
		local abil = dummi:FindAbilityByName("lycan_summon_wolves")
		print (abil)
		abil:SetLevel(1)
		dummi:CastAbilityNoTarget(abil, dummi:GetPlayerOwnerID())
		
		self:GetParent():AddAbility("lycan_summon_wolves")
		local abil = self:GetParent():FindAbilityByName("lycan_summon_wolves")
		print (self:GetParent())
		print (abil)
		print (self:GetParent():GetPlayerOwnerID())
		print (abil:IsOwnersManaEnough())
		abil:SetLevel(1)
		self:GetParent():CastAbilityNoTarget(abil, -1)
		--(self:GetCaster():GetOrigin(), abil, -1)]]
		
		--UTIL_Remove( self:GetParent() )
	end
end

