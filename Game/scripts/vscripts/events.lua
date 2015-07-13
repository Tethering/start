--[[ events.lua ]]

--------------------------------------------------------------------------------
-- Event: OnItemPurchased
--------------------------------------------------------------------------------
function CMWGameMode:OnItemPurchased( event )
	local ability_name = event.itemname
	local user = PlayerResource:GetPlayer( event.PlayerID )
	local hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()
	

	if ability_name == "item_earth_arrow" then 
		if hero:FindAbilityByName("earth_arrow_lua") then
			hero:SetGold((hero:GetGold() + 100), true)
			hero:SetGold(0, false)
			return
		end
		
		hero:RemoveAbility("earth_arrow_lua")
		hero:RemoveAbility("common_arrow_lua")
	
		hero:AddAbility("earth_arrow_lua")
		hero:FindAbilityByName("earth_arrow_lua"):SetLevel(1)
	end
end


--------------------------------------------------------------------------------
-- Event: OnHeroPicked
--------------------------------------------------------------------------------
function CMWGameMode:OnHeroPicked( event )
	print("CMWGameMode:OnHeroPicked( event )")
	
	local pickedHero = EntIndexToHScript( event.heroindex )
	if pickedHero:IsRealHero() then
		local ability_leap = pickedHero:FindAbilityByName("common_leap")
		if ability_leap then ability_leap:UpgradeAbility(true) end
		
		local ability_arrow = pickedHero:FindAbilityByName("common_arrow_lua")
		if ability_arrow then ability_arrow:UpgradeAbility(true) end
		
		--local ability_arrow = pickedHero:FindAbilityByName("earth_arrow_lua")
		--if ability_arrow then ability_arrow:UpgradeAbility(true) end
		
		--pickedHero:RemoveAbility("common_arrow_lua")
		
		pickedHero:SetAbilityPoints ( 0 )
	end
	
	print("CMWGameMode:OnHeroPicked( event ) ends")
end


---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function CMWGameMode:OnGameRulesStateChange()
	print("CMWGameMode:OnGameRulesStateChange()")
	
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers > 7 then
			self.TEAM_KILLS_TO_WIN = 30
			nCOUNTDOWNTIMER = 901
		elseif numberOfPlayers > 4 and numberOfPlayers <= 7 then
			self.TEAM_KILLS_TO_WIN = 25
			nCOUNTDOWNTIMER = 721
		else
			--self.TEAM_KILLS_TO_WIN = 20
			--nCOUNTDOWNTIMER = 601
			self.TEAM_KILLS_TO_WIN = 10
			nCOUNTDOWNTIMER = 301
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
	print("CMWGameMode:OnNPCSpawned( event )")
	
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
	print("CMWGameMode:OnTeamKillCredit( event )")
	
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
	print("CMWGameMode:OnEntityKilled( event )")
	
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
				hero:AddExperience( 100, 0, false, false )
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
				hero:AddExperience( 50, 0, false, false )
			end
		end
		--Granting XP to all heroes who assisted
		local allHeroes = HeroList:GetAllHeroes()
		for _,attacker in pairs( allHeroes ) do
			--print(killedUnit:GetNumAttackers())
			for i = 0, killedUnit:GetNumAttackers() - 1 do
				if attacker == killedUnit:GetAttacker( i ) then
					--print("Granting assist xp")
					attacker:AddExperience( 25, 0, false, false )
				end
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
	print("CMWGameMode:SetRespawnTime( killedTeam, killedUnit )")
	
	--print("Setting time for respawn")
	if killedTeam == self.leadingTeam and self.isGameTied == false then
		killedUnit:SetTimeUntilRespawn(20)
	else
		killedUnit:SetTimeUntilRespawn(10)
	end
end