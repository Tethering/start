modifier_item_owls = class({})
--------------------------------------------------------------------------------

function modifier_item_owls:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_owls:CheckState()
	local state = {
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}

	return state
end