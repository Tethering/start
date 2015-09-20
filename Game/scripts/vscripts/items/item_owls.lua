LinkLuaModifier( "modifier_item_owls", LUA_MODIFIER_MOTION_NONE )

function item_owls_on_spell_start(keys)	
	for key, val in pairs(keys) do  -- Table iteration.
	 	 print(key, val)
	end

	caster = keys.caster
	tree = keys.target
	item = keys.ability

	if not tree.assigned_owl then
		owl = CreateUnitByName("npc_owl", tree:GetOrigin(), false, keys.caster, keys.caster, keys.caster:GetTeam())
		owl:SetOrigin(owl:GetOrigin() + Vector(0,0,100))
		owl:AddNewModifier( caster, item, "modifier_item_owls", { duration = 10000 } )

		--[[local particle = ParticleManager:CreateParticle( "particles/econ/items/natures_prophet/natures_prophet_weapon_birdstone/furion_staff_glow_birdstone.vpcf", PATTACH_OVERHEAD_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 1000, 1, 1 ) )

		
		particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_ambient_body_stars.vpcf", PATTACH_OVERHEAD_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 1000, 1, 1 ) )
		]]

		particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_deafening_blast_debuff_feet.vpcf", PATTACH_OVERHEAD_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 300, 0, 0 ) )

		particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_deafening_blast_debuff_echo_demo.vpcf", PATTACH_ABSORIGIN_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 300, 0, 0 ) )
		
		particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_deafening_blast_debuff_debris.vpcf", PATTACH_ABSORIGIN_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 300, 0, 0 ) )

		particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_b_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, owl )
		ParticleManager:SetParticleControl( particle, 0, owl:GetOrigin() )
		ParticleManager:SetParticleControl( particle, 1, Vector( 300, 0, 0 ) )
		

		tree.assigned_owl = owl


		if item:GetCurrentCharges() > 1 then
			item:SetCurrentCharges(item:GetCurrentCharges() - 1)
		else
			caster:RemoveItem(item)
		end
	end
end