modifier_earth_arrow_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:GetTexture()
	return "brewmaster_thunder_clap"
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_earth_arrow_effect_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor( "earth_slow" )
end

function modifier_earth_arrow_effect_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor( "earth_slow" )
end

--------------------------------------------------------------------------------

function modifier_earth_arrow_effect_lua:CheckState()
	local state = {}
	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
