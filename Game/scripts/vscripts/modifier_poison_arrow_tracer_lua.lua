modifier_poison_arrow_tracer_lua = class({})
--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf"
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:OnCreated( kv )
	print (kv)
	self:StartIntervalThink( 0.1 )
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:OnIntervalThink()
	target = self:GetParent()
	enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetOrigin(), nil, self:GetAbility():GetSpecialValueFor("poison_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_poison_arrow_effect_lua", { duration = 5 } )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:OnDestroy()
	UTIL_Remove(self:GetParent())
end

--------------------------------------------------------------------------------

function modifier_poison_arrow_tracer_lua:CheckState()
	local state = {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end