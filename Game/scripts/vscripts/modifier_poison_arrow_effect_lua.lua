modifier_poison_arrow_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_poison_arrow_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_effect_lua:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_effect_lua:GetTexture()
	return "viper_poison_attack"
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_effect_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_effect_lua:OnCreated()
	self:StartIntervalThink( 0.01 )
end

function modifier_poison_arrow_effect_lua:OnIntervalThink()
	local damage = {
		victim = self:GetParent(),
		attacker = self:GetAbility():GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor("poison_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}

	ApplyDamage( damage )
	self:StartIntervalThink( 1.00 )
end