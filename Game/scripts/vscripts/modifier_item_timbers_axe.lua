modifier_item_timbers_axe = class({})
--------------------------------------------------------------------------------

function modifier_item_timbers_axe:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_timbers_axe:GetEffectName()
	return "particles/items_fx/healing_tango.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_timbers_axe:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_item_timbers_axe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_item_timbers_axe:GetModifierConstantHealthRegen()
	local parent = self:GetParent()
	if parent.timbers_axe_bonus then
		return self:GetAbility():GetSpecialValueFor("super_heal")/self:GetAbility():GetSpecialValueFor("duration")
	else
		return self:GetAbility():GetSpecialValueFor("heal")/self:GetAbility():GetSpecialValueFor("duration")
	end
end