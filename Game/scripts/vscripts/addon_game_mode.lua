-- Generated from template

_G.nCOUNTDOWNTIMER = 901

if CMWGameMode == nil then
	_G.CMWGameMode = class({})
end

---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
require( "events" )
--require( "items" )
require( "utility_functions" )


---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )

	--items
	--Skull of Freeze
	PrecacheResource( "particle", "particles/items_fx/aura_shivas.vpcf", context )

	--Shield of Protection
	PrecacheResource( "particle", "particles/items_fx/aura_assault.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/buckler.vpcf", context )

	--Drums
	PrecacheResource( "particle", "particles/items_fx/aura_endurance.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/drum_of_endurance_buff.vpcf", context )

	--Healing Artifact
	PrecacheResource( "particle", "particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", context )

	--Staff of Moon
	PrecacheResource( "model", "models/heroes/drow/drow.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_bracers.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_cape.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_weapon.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_legs.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_quiver.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_shoulders.vmdl", context )
	PrecacheResource( "model", "models/heroes/drow/drow_haircowl.vmdl", context )
	PrecacheResource( "particle", "particles/items2_fx/necronomicon_archer_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/necronomicon_archer_manaburn.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_stunned.vpcf", context )
	
	--Shield of Lick
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_static_storm_bolt_hero.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_ring.vpcf", context )

	--arrows
	--Common Arrow
	PrecacheResource( "particle", "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context )

	--Earth Arrow
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )

	--Damnation Arrow
	PrecacheResource("particle", "particles/items2_fx/medallion_of_courage.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", context) 
	--PrecacheResource("particle", "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf", context) 
	--PrecacheResource("particle", "particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", context) 
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context )


	--Poison Arrow
	PrecacheResource("particle", "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf", context)


	--Vampirice Arrow
	PrecacheResource("particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", context)


	
	
	--Chacing Arrow
	--particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion_fireworks.vpcf
	
	--particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf
	--particles/units/heroes/hero_batrider/batrider_firefly.vpcf
	--PrecacheResource("particle", "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", context)


	--[[Returns:void
	Manually precache a single resource
	]]
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	print("Activate")
	
	GameRules.MW = CMWGameMode()
	GameRules.MW:InitGameMode()
end



---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function CMWGameMode:InitGameMode()
	print("CMWGameMode:InitGameMode()")
	
	print( "Mirana Wars Reborn is loaded." )
	
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple
	
	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"
	
	
	self.m_GatheredShuffledTeams = {}
	--self.numSpawnCamps = 5				-
	--self.specialItem = ""					-
	--self.spawnTime = 120					-
	--self.nNextSpawnItemNumber = 1			-
	--self.hasWarnedSpawn = false			-
	--self.allSpawned = false				-
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	
	
	self.TEAM_KILLS_TO_WIN = 30
	self.CLOSE_TO_VICTORY_THRESHOLD = 5
	
	
	--------------------------------------------
	self:GatherAndRegisterValidTeams()
	--------------------------------------------
	
	
	
	GameRules:SetCustomGameEndDelay( 0 )
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetPreGameTime( 10 )
	GameRules:SetHeroMinimapIconScale( 1.7 )
	GameRules:SetGoldPerTick( 1 )
	GameRules:SetGoldTickTime( 0.6 )
	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( false )
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( true )
	--GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( false )
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( 1 )
	
	----------------------------------------------------
	--Couple of Listeners
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CMWGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CMWGameMode, "OnNPCSpawned" ), self ) 										--try to remove
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( CMWGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CMWGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CMWGameMode, 'OnHeroPicked' ), self )
	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CMWGameMode, 'OnItemPurchased' ), self )
	
	
	Convars:RegisterCommand( "overthrow_set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_end_game", function(...) return self:EndGame( DOTA_TEAM_GOODGUYS ) end, "Force the game to end.", FCVAR_CHEAT )
	
	
	
	
	----------------------------------------------------
	
	
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
	
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end




---------------------------------------------------------------------------
---------------------------------------------------------------------------
function CMWGameMode:EndGame( victoryTeam )
	print("CMWGameMode:EndGame( victoryTeam )")
	
	--[[
		local overBoss = Entities:FindByName( nil, "@overboss" )
		if overBoss then
			local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
			if celebrate then
				overBoss:CastAbilityNoTarget( celebrate, -1 )
			end
		end
	]]--

	GameRules:SetGameWinner( victoryTeam )
end


---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function CMWGameMode:ColorForTeam( teamID )
	--print("CMWGameMode:ColorForTeam( teamID )")
	
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function CMWGameMode:UpdatePlayerColor( nPlayerID )
	--print("CMWGameMode:UpdatePlayerColor( nPlayerID )")
	
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function CMWGameMode:UpdateScoreboard()
	--print("CMWGameMode:UpdateScoreboard()")
	
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score = 
		{
			team_id = t.teamID,
			team_score = t.teamScore
		}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end



function CMWGameMode:OnThink()
	--print("CMWGameMode:OnThink()")
	
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end
		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				CMWGameMode:EndGame( self.leadingTeam )
				self.countdownEnabled = false
			else
				self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
				local broadcast_killcount = 
				{
					killcount = self.TEAM_KILLS_TO_WIN
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
       	end
	end

	return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function CMWGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end