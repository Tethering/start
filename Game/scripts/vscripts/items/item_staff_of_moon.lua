function item_staff_of_moon_on_spell_start(keys)	
	keys.caster:EmitSound("DOTA_Item.Necronomicon.Activate")

	local vec = keys.caster:GetForwardVector()
	local arch = {}
	local i
	for i = 1, 3 do  -- The range includes both ends.
		local vPos = keys.caster:GetOrigin() + Vector(vec.x * 70 * i, vec.y * 70 * i, 0)
		arch[i] = CreateUnitByName("npc_archer", vPos, true, keys.caster, keys.caster, keys.caster:GetTeam())
		FindClearSpaceForUnit( arch[i], vPos, true )
		arch[i]:SetOwner(keys.caster)
	    arch[i]:SetControllableByPlayer(keys.caster:GetPlayerID(),true)
	    local abil = arch[i]:FindAbilityByName("archers_headshot") 
	    abil:SetLevel(1)
	end
	
	for i = 1, 3 do
		Timers:CreateTimer(function()
			if arch[i]:GetMana() > 0 then
				-- Tracer dummy
				arch[i]:SetMana(arch[i]:GetMana() - 1)
				
				return 1.0
			else
				local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/necronomicon_archer_manaburn.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, arch[i]:GetAbsOrigin() )
				ParticleManager:SetParticleControl(	nFXIndex, 1, arch[i]:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				UTIL_Remove(arch[i])
				return nil
			end
		end)
	end
end