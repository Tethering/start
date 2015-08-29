modifier_damnation_arrow_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:GetTexture()
	return "queenofpain_shadow_strike"
end

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_damnation_arrow_effect_lua:GetModifierPhysicalArmorBonus( params )
	return self:GetAbility():GetSpecialValueFor( "damnation_armor_reduce" )
end

--------------------------------------------------------------------------------

function modifier_damnation_arrow_effect_lua:CheckState()
	local state = {}
	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
