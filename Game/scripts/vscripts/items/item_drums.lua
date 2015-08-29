function item_drums_on_spell_start(keys)	
	keys.caster:EmitSound("DOTA_Item.DoE.Activate")

	local nearby_allied_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, keys.ActiveRadius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for i, nearby_ally in ipairs(nearby_allied_units) do
		keys.ability:ApplyDataDrivenModifier(keys.caster, nearby_ally, "modifier_drums_active", {duration = keys.ActiveDuration})
	end
end