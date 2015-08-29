modifier_hunters_arrow_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:OnCreated()
	print ("modifier_hunters_arrow_effect_lua created")
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:GetTexture()
	return "windrunner_powershot"
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:DeclareFunctions()
	local funcs = {}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_hunters_arrow_effect_lua:CheckState()
	local state = {}
	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
