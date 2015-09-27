--[[ events.lua ]]

--a function that finds an item on a unit by name
function findItemOnUnit( unit, itemname, searchStash )
    --check if the unit has the item at all
    if not unit:HasItemInInventory( itemname ) then
        return nil
    end
    
    --set a search range depending on if we want to search the stach or not
    local lastSlot = 5
    if searchStash then
        lastSlot = 11
    end
    
    --go past all slots to see if the item is there
    for slot= 0, lastSlot, 1 do
        local item = unit:GetItemInSlot( slot )
        if item:GetAbilityName() == itemname then
            return item
        end
    end
    
    --if the item is not found, return nil (happens if the item is in stash and you are not looking in stash)
    return nil
end

--a function that finds an item on a unit by name
function countItemOnUnit( unit, itemname, searchStash )
	local count = 0
    --check if the unit has the item at all
    if not unit:HasItemInInventory( itemname ) then
        return count
    end
    
    --set a search range depending on if we want to search the stach or not
    local lastSlot = 5
    if searchStash then
        lastSlot = 11
    end
    
    --go past all slots to see if the item is there
    for slot= 0, lastSlot, 1 do
        local item = unit:GetItemInSlot( slot )
        if item:GetAbilityName() == itemname then
            count = count + 1
        end
    end
    
    --if the item is not found, return nil (happens if the item is in stash and you are not looking in stash)
    return count
end

--a function that finds an item on a unit by name
function countAllItemsOnUnit( unit, searchStash )
	local count = 0
    --check if the unit has the item at all
    
    --set a search range depending on if we want to search the stach or not
    local lastSlot = 5
    if searchStash then
        lastSlot = 11
    end
    
    --go past all slots to see if the item is there
    for slot= 0, lastSlot, 1 do
        if unit:GetItemInSlot( slot ) then
            count = count + 1
        end
    end
    
    --if the item is not found, return nil (happens if the item is in stash and you are not looking in stash)
    return count
end



--------------------------------------------------------------------------------
-- Event: OnItemPurchased
--------------------------------------------------------------------------------

--[[function CMWGameMode:OnPlayerTeam( event )
	if event.disconnect then
		self.isPlayerDisconnected[event.userid] = true
	end
end

function CMWGameMode:OnPlayerReconnceted( event )
	self.isPlayerDisconnected[event.PlayerID] = false
	hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()

	hero:SetRespawnTime(10) 
end]]

function RemoveAbility_and_ReturnCooldown( hero )
	local cdr
	if hero:FindAbilityByName("common_arrow_lua") then
		cdr = hero:FindAbilityByName("common_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("common_arrow_lua")
	end
	if hero:FindAbilityByName("earth_arrow_lua") then
		cdr = hero:FindAbilityByName("earth_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("earth_arrow_lua")
	end
	if hero:FindAbilityByName("damnation_arrow_lua") then
		cdr = hero:FindAbilityByName("damnation_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("damnation_arrow_lua")
	end
	if hero:FindAbilityByName("neutron_arrow_lua") then
		cdr = hero:FindAbilityByName("neutron_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("neutron_arrow_lua")
	end
	if hero:FindAbilityByName("poison_arrow_lua") then
		cdr = hero:FindAbilityByName("poison_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("poison_arrow_lua")
	end
	if hero:FindAbilityByName("vampire_arrow_lua") then
		cdr = hero:FindAbilityByName("vampire_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("vampire_arrow_lua")
	end
	if hero:FindAbilityByName("triplex_arrow_lua") then
		cdr = hero:FindAbilityByName("triplex_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("triplex_arrow_lua")
	end
	if hero:FindAbilityByName("fire_arrow_lua") then
		cdr = hero:FindAbilityByName("fire_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("fire_arrow_lua")
	end
	if hero:FindAbilityByName("hunters_arrow_lua") then
		cdr = hero:FindAbilityByName("hunters_arrow_lua"):GetCooldownTimeRemaining()
		hero:RemoveAbility("hunters_arrow_lua")
	end	
	return cdr
end
--------------------------------------------------------------------------------
-- Event: OnItemPurchased
--------------------------------------------------------------------------------
function CMWGameMode:OnItemPurchased( event )


	local dota_item = true
	local ability_name = event.itemname
	local hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()
	
	--------------------------------------------------
	--Regular Items
	--------------------------------------------------

	if countAllItemsOnUnit(hero, true) == 7 then
		hero:SellItem(hero:GetItemInSlot(6))
	end


	--[[if ability_name == "item_shield_of_luck" then
		if countItemOnUnit(hero, "item_shield_of_luck", false) > 1 then
			hItem = findItemOnUnit(hero, ability_name, false)
			hero:RemoveItem(hItem)
			hero:SetGold((hero:GetGold() + event.itemcost), true)
			hero:SetGold(0, false)
			return
		end
	end

	if ability_name == "item_blood_bow" then
		if countItemOnUnit(hero, "item_blood_bow", false) > 1 then
			hItem = findItemOnUnit(hero, ability_name, false)
			hero:RemoveItem(hItem)
			hero:SetGold((hero:GetGold() + event.itemcost), true)
			hero:SetGold(0, false)
			return
		end
	end]]


	--------------------------------------------------	
	--Removing the bug when you were not able to buy arrow while invetory is full
	--------------------------------------------------
	--[[local cant_buy_arrow_bug = false
	local item = hero:GetItemInSlot(0)
	if item then
		local cd = item:GetCooldownTimeRemaining()
		temp_name = item:GetAbilityName()
		hero:RemoveItem(item)
		cant_buy_arrow_bug = true
	end]]

	--------------------------------------------------
	--Arrows
	--------------------------------------------------
	if string.find(ability_name, "_arrow") then
		local arrow_ability = string.gsub(ability_name, "_arrow", "_arrow_lua")
		arrow_ability = string.gsub(arrow_ability, "item_", "")
		

		dota_item = false    --BUG FIX: Players are not able to buy original DOTA items

		--------------------------------------------------
		--BUG GIX: Cant buy the same arrow twice in row
		----------------
		if hero:FindAbilityByName(arrow_ability) then
			hero:SetGold((hero:GetGold() + event.itemcost), true)
			hero:SetGold(0, false)
			return
		end
		----------------
		--------------------------------------------------

		local cdr = RemoveAbility_and_ReturnCooldown(hero)
	
		hero:AddAbility(arrow_ability)
		hero:FindAbilityByName(arrow_ability):SetLevel(1)
		hero:FindAbilityByName(arrow_ability):StartCooldown(cdr)
	end


	--------------------------------------------------	
	--BUG FIX: Players are not able to buy original DOTA items
	--------------------------------------------------

	if ability_name == "item_staff_of_wizard" then dota_item = false end
	if ability_name == "item_axe_of_illusion" then dota_item = false end
	if ability_name == "item_shield_of_protection" then dota_item = false end
	if ability_name == "item_drums" then dota_item = false end
	if ability_name == "item_healing_artifact" then dota_item = false end
	if ability_name == "item_staff_of_moon" then dota_item = false end
	--if ability_name == "item_protective_wall" then dota_item = false end
	if ability_name == "item_health_stone" then dota_item = false end
	if ability_name == "item_mask_of_anabolism" then dota_item = false end
	if ability_name == "item_dodge_talisman" then dota_item = false end
	if ability_name == "item_spectres_hood" then dota_item = false end
	if ability_name == "item_bow_of_wind" then dota_item = false end
	if ability_name == "item_guard_of_freeze" then dota_item = false end
	if ability_name == "item_shield_of_luck" then dota_item = false end
	if ability_name == "item_blood_bow" then dota_item = false end
	if ability_name == "item_owls" then dota_item = false end
	if ability_name == "item_timbers_axe" then dota_item = false end

	

	if dota_item then
		hero:RemoveItem(findItemOnUnit(hero, ability_name, false))
		hero:SetGold((hero:GetGold() + event.itemcost), true)
		hero:SetGold(0, false)
	end

	--------------------------------------------------	
	--Removing the bug when you were not able to buy arrow while invetory is full
	--------------------------------------------------

	--[[if cant_buy_arrow_bug then
		hero:AddItemByName(temp_name)
	end]]


end


--------------------------------------------------------------------------------
-- Event: OnHeroPicked
--------------------------------------------------------------------------------
function CMWGameMode:OnHeroPicked( event )
	
	local pickedHero = EntIndexToHScript( event.heroindex )
	if pickedHero:IsRealHero() then
		local ability_leap = pickedHero:FindAbilityByName("common_leap")
		if ability_leap then ability_leap:UpgradeAbility(true) end
		
		local ability_arrow = pickedHero:FindAbilityByName("common_arrow_lua")
		if ability_arrow then ability_arrow:UpgradeAbility(true) end
		
		pickedHero:SetAbilityPoints ( 0 )
		pickedHero:SetGold(0, false)
		pickedHero:SetGold(0, true)

	end
	
end


---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function CMWGameMode:OnGameRulesStateChange()
	
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers > 7 then
			self.TEAM_KILLS_TO_WIN = 35
			nCOUNTDOWNTIMER = 2101
		elseif numberOfPlayers > 4 and numberOfPlayers <= 7 then
			self.TEAM_KILLS_TO_WIN = 30
			nCOUNTDOWNTIMER = 1801
		else
			self.TEAM_KILLS_TO_WIN = 25
			nCOUNTDOWNTIMER = 1501
			--self.TEAM_KILLS_TO_WIN = 10
			--nCOUNTDOWNTIMER = 301
		end
		--print( "Kills to win = " .. tostring(self.TEAM_KILLS_TO_WIN) )

		CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = self.TEAM_KILLS_TO_WIN } );

		self._fPreGameStartTime = GameRules:GetGameTime()
	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
	end
end

--------------------------------------------------------------------------------
-- Event: OnNPCSpawned
--------------------------------------------------------------------------------
function CMWGameMode:OnNPCSpawned( event )
	
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		-- Destroys the last hit effects
		local deathEffects = spawnedUnit:Attribute_GetIntValue( "effectsID", -1 )
		if deathEffects ~= -1 then
			ParticleManager:DestroyParticle( deathEffects, true )
			spawnedUnit:DeleteAttribute( "effectsID" )
		end
		if self.allSpawned == false then
			if GetMapName() == "mines_trio" then
				--print("mines_trio is the map")
				--print("self.allSpawned is " .. tostring(self.allSpawned) )
				local unitTeam = spawnedUnit:GetTeam()
				local particleSpawn = ParticleManager:CreateParticleForTeam( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, spawnedUnit, unitTeam )
				ParticleManager:SetParticleControlEnt( particleSpawn, PATTACH_ABSORIGIN, spawnedUnit, PATTACH_ABSORIGIN, "attach_origin", spawnedUnit:GetAbsOrigin(), true )
			end
		end
	end
end



---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
function CMWGameMode:OnTeamKillCredit( event )
	
--	print( "OnKillCredit" )
--	DeepPrint( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.TEAM_KILLS_TO_WIN - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function CMWGameMode:OnEntityKilled( event )
	
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	if killedUnit:IsRealHero() then
		self.allSpawned = true
		--print("Hero has been killed")
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			--print("Granting killer xp")
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then
				local memberID = hero:GetPlayerID()
				PlayerResource:ModifyGold( memberID, 500, true, 0 )
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			end
		end
		
		if killedUnit:GetRespawnTime() > 10 then
			--print("Hero has long respawn time")
			if killedUnit:IsReincarnating() == true then
				--print("Set time for Wraith King respawn disabled")
				return nil
			else
				CMWGameMode:SetRespawnTime( killedTeam, killedUnit )
			end
		else
			CMWGameMode:SetRespawnTime( killedTeam, killedUnit )
		end
	end
end

function CMWGameMode:SetRespawnTime( killedTeam, killedUnit )
	--[[if self.isPlayerDisconnected[killedUnit:GetPlayerID()] then
		if killedTeam == self.leadingTeam and self.isGameTied == false then
			killedUnit:SetTimeUntilRespawn(20000)
		else
			killedUnit:SetTimeUntilRespawn(10000)
		end
	else]]
		if killedTeam == self.leadingTeam and self.isGameTied == false then
			killedUnit:SetTimeUntilRespawn(20)
		else
			killedUnit:SetTimeUntilRespawn(10)
		end
	--end
	

	RespawnPositions = {{-1536,4608,0},{-2304,2560,0},{-1280,1024,0},{437,903,0},{2816,-1280,0},{2816,2048,0},{2668,4608,0}}
	local vec = killedUnit:GetForwardVector()
	rand = RandomInt(1, 7)
	vec.x = RespawnPositions[rand][1]
	vec.y = RespawnPositions[rand][2]
	vec.z = 0
	killedUnit:SetRespawnPosition(vec)
end