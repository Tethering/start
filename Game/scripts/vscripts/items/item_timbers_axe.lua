LinkLuaModifier( "modifier_item_timbers_axe", LUA_MODIFIER_MOTION_NONE )

function item_timbers_axe_on_spell_start(keys)

	caster = keys.caster
	tree = keys.target
	item = keys.ability

	caster.timbers_axe_bonus = false
	if tree.assigned_owl then
		owl = tree.assigned_owl

		UTIL_Remove(owl)

		caster.timbers_axe_bonus = true
	end
	caster:AddNewModifier( caster, item, "modifier_item_timbers_axe", { duration = 10 } )

	tree:CutDownRegrowAfter(RandomFloat(10.0, 20.0), caster:GetTeamNumber())
	tree.assigned_owl = nil
end