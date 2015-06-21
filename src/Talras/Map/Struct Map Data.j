library StructMapMapMapData requires Asl, AStructSystemsCharacterVideo, StructGameCharacter, StructGameClasses, StructGameGame, StructMapMapShrines, StructMapMapNpcRoutines, StructMapQuestsQuestTalras, StructMapQuestsQuestTheNorsemen, MapVideos

	//! inject config
		 call SetMapName( "TRIGSTR_001" )
		call SetMapDescription( "" )
		call SetPlayers( 12 )
		call SetTeams( 12 )
		call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )

		call DefineStartLocation( 0, -22592.0, 18944.0 )
		call DefineStartLocation( 1, -22592.0, 18944.0 )
		call DefineStartLocation( 2, -22592.0, 18944.0 )
		call DefineStartLocation( 3, -22592.0, 18944.0 )
		call DefineStartLocation( 4, -22592.0, 18944.0 )
		call DefineStartLocation( 5, -22592.0, 18944.0 )
		call DefineStartLocation( 6, -22592.0, 18944.0 )
		call DefineStartLocation( 7, -22592.0, 18944.0 )
		call DefineStartLocation( 8, -22592.0, 18944.0 )
		call DefineStartLocation( 9, -22592.0, 18944.0 )
		call DefineStartLocation( 10, -22592.0, 18944.0 )
		call DefineStartLocation( 11, -22592.0, 18944.0 )

		// Player setup
		call InitCustomPlayerSlots(  )
		call InitCustomTeams(  )
		call InitAllyPriorities(  )

		call PlayMusic("Music\\LoadingScreen.mp3") /// WARNING: If file does not exist, game crashes?
	//! endinject

	/**
	 * \brief A static class which defines unit type ids with identifiers.
	 */
	struct UnitTypes
		public static constant integer orcCrossbow = 'n01A'
		public static constant integer orcBerserk = 'n01G'
		public static constant integer orcWarlock = 'n018'
		public static constant integer orcWarrior = 'n019'
		public static constant integer orcGolem = 'n025'
		public static constant integer orcPython = 'n01F'
		public static constant integer orcLeader = 'n02P'
		public static constant integer darkElfSatyr = 'n02O'
		public static constant integer norseman = 'n01I'
		public static constant integer ranger = 'n03F'
		public static constant integer armedVillager = 'n03H'

		public static constant integer deathAngel = 'n02K'
		public static constant integer vampire = 'n02L'
		public static constant integer vampireLord = 'n010'
		public static constant integer doomedMan = 'n037'
		public static constant integer deacon = 'n035'
		public static constant integer ravenJuggler = 'n036'
		public static constant integer degenerateSoul = 'n038'
		public static constant integer medusa = 'n033'
		public static constant integer thunderCreature = 'n034'

		public static constant integer boneDragon = 'n024' /// \todo FIXME
		public static constant integer osseousDragon = 'n024'
		
		public static constant integer deranor = 'u00A'
		
		public static constant integer cornEater = 'n016'

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method spawn takes player whichPlayer, real x, real y returns nothing
			call CreateUnit(whichPlayer, thistype.orcCrossbow, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcBerserk, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcWarlock, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcWarrior, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcGolem, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcPython, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcLeader, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.darkElfSatyr, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.norseman, x, y, GetRandomFacing())
		endmethod
	endstruct

	struct MapData extends MapDataInterface
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
		public static constant integer maxPlayers = 6
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(7)
		public static constant player arenaPlayer = Player(8)
		public static constant real morning = 5.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real videoWaitInterval = 1.0
		public static constant real revivalTime = 20.0
		public static constant integer startSkillPoints = 3
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 25
		public static constant integer workerUnitTypeId = 'h00E'
		public static constant player orcPlayer = Player(9)
		public static constant player haldarPlayer = Player(10)
		public static constant player baldarPlayer = Player(11)
		
		private static boolean m_startedGameAfterIntro = false
		private static region m_welcomeRegion
		private static trigger m_welcomeTalrasTrigger
		
		private static region m_portalsHintRegion
		private static trigger m_portalsHintTrigger
		private static boolean array m_portalsHintShown[6]
		
		private static region m_talkHintRegion
		private static trigger m_talkHintTrigger
		private static boolean array m_talkHintShown[6]

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		private static method triggerConditionWelcomeTalras takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit())
		endmethod
		
		private static method triggerActionWelcomeTalras takes nothing returns nothing
			local force humans = GetPlayersByMapControl(MAP_CONTROL_USER)
			call TransmissionFromUnitWithNameBJ(humans, gg_unit_n015_0149, tr("Krieger"), null, tr("Willkommen in Talras!"), bj_TIMETYPE_ADD, 0.0, false)
			call DisableTrigger(GetTriggeringTrigger())
			call DestroyForce(humans)
			set humans = null
			call RemoveRegion(thistype.m_welcomeRegion)
			set thistype.m_welcomeRegion = null
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod
		
		private static method triggerConditionPortalsHint takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not thistype.m_portalsHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
		endmethod
		
		private static method triggerActionPortalsHint takes nothing returns nothing
			call Character(ACharacter.getCharacterByUnit(GetTriggerUnit())).displayHint("Magische Kreise auf der Karte dienen als Portale. Schicken Sie Einheiten auf die Kreise, um sie an verschiedene Punkte auf der Karte zu bewegen.")
			set thistype.m_portalsHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = true
		endmethod
		
		private static method triggerConditionTalkHint takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not thistype.m_talkHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
		endmethod
		
		private static method triggerActionTalkHint takes nothing returns nothing
			call Character(ACharacter.getCharacterByUnit(GetTriggerUnit())).displayHint("Schicken Sie ihren Charakter in der Nähe eines NPCs mit Ausrufezeichen auf diesen, um ihn anzusprechen.")
			set thistype.m_talkHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = true
		endmethod
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SetPlayerAllianceStateBJ(Player(i), MapData.orcPlayer, bj_ALLIANCE_UNALLIED)
				call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(i), bj_ALLIANCE_UNALLIED)
				set i = i + 1
			endloop
			
			call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapData.orcPlayer, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(MapData.orcPlayer, MapData.alliedPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, MapData.orcPlayer, bj_ALLIANCE_UNALLIED)
			
			call Aos.init.evaluate()
			call Arena.init(GetRectCenterX(gg_rct_arena_outside), GetRectCenterY(gg_rct_arena_outside), 0.0, tr("Sie haben die Arena betreten."), tr("Sie haben die Arena verlassen."), tr("Ein Arenakampf beginnt nun."), tr("Ein Arenakampf endet nun. Der Gewinner ist \"%1%\" und er bekommt %2% Goldmünzen."))
			call Arena.addRect(gg_rct_arena_0)
			call Arena.addRect(gg_rct_arena_1)
			call Arena.addRect(gg_rct_arena_2)
			call Arena.addRect(gg_rct_arena_3)
			call Arena.addRect(gg_rct_arena_4)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_0), GetRectCenterY(gg_rct_arena_enemy_0), 180.0)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_1), GetRectCenterY(gg_rct_arena_enemy_1), 0.0)
			
static if (DMDF_NPC_ROUTINES) then
			/*
			 * Extract this call since it contains many many calls which should be executed in a different trigger to avoid OpLimit.
			 * Usually you would simply use .evaluate() which is synchronous and evaluates a trigger which has its own OpLimit.
			 * Unfortunately for calling already declared methods with .evaluate() the JassHelper does not generate such a trigger evaluation.
			 * This workaround can be used for parameterless functions and calls the function with a separate OpLimit as well.
			 */
			call ForForce(bj_FORCE_PLAYER[0], function NpcRoutines.init)
endif
			call Shrines.init()
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoints.init)
			call ForForce(bj_FORCE_PLAYER[0], function Tavern.init)
			call ForForce(bj_FORCE_PLAYER[0], function Tomb.init)
			/*
			 * For functions the JassHelper always generates a TriggerEvaluate() call.
			 */
			call initMapSpells.evaluate()
			call initMapTalks.evaluate()
			call initMapVideos.evaluate()
			call ForForce(bj_FORCE_PLAYER[0], function Fellows.init) // init after talks (new)
			// weather
			call Game.weather().setMinimumChangeTime(20.0)
			call Game.weather().setMaximumChangeTime(60.0)
			call Game.weather().setChangeSky(false) // TODO prevent lags?
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainHeavy, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainLight, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeNoWeather, true)
			call Game.weather().addRect(gg_rct_area_playable)
			
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
			set thistype.m_welcomeTalrasTrigger = CreateTrigger()
			set thistype.m_welcomeRegion = CreateRegion()
			call RegionAddRect(thistype.m_welcomeRegion, gg_rct_quest_talras_quest_item_0)
			call TriggerRegisterEnterRegion(thistype.m_welcomeTalrasTrigger, thistype.m_welcomeRegion, null)
			call TriggerAddCondition(thistype.m_welcomeTalrasTrigger, Condition(function thistype.triggerConditionWelcomeTalras))
			call TriggerAddAction(thistype.m_welcomeTalrasTrigger, function thistype.triggerActionWelcomeTalras)
			
			set thistype.m_portalsHintTrigger = CreateTrigger()
			set thistype.m_portalsHintRegion = CreateRegion()
			call RegionAddRect(thistype.m_portalsHintRegion, gg_rct_hint_portals)
			call TriggerRegisterEnterRegion(thistype.m_portalsHintTrigger, thistype.m_portalsHintRegion, null)
			call TriggerAddCondition(thistype.m_portalsHintTrigger, Condition(function thistype.triggerConditionPortalsHint))
			call TriggerAddAction(thistype.m_portalsHintTrigger, function thistype.triggerActionPortalsHint)
			
			set thistype.m_talkHintRegion = CreateRegion()
			set thistype.m_talkHintTrigger = CreateTrigger()
			call RegionAddRect(thistype.m_talkHintRegion, gg_rct_hint_talk)
			call TriggerRegisterEnterRegion(thistype.m_talkHintTrigger, thistype.m_talkHintRegion, null)
			call TriggerAddCondition(thistype.m_talkHintTrigger, Condition(function thistype.triggerConditionTalkHint))
			call TriggerAddAction(thistype.m_talkHintTrigger, function thistype.triggerActionTalkHint)
		endmethod
		
		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassItems takes AClass class, unit whichUnit returns nothing
			if (class == Classes.ranger()) then
				// Hunting Bow
				call UnitAddItemById(whichUnit, 'I020')
			elseif (class == Classes.cleric() or class == Classes.necromancer() or class == Classes.elementalMage() or class == Classes.wizard()) then	
				// Haunted Staff
				call UnitAddItemById(whichUnit, 'I03V')
			else
				call UnitAddItemById(whichUnit, ItemTypes.shortword().itemType())
				call UnitAddItemById(whichUnit, ItemTypes.lightWoodenShield().itemType())
			endif
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call UnitAddItemById(whichUnit, 'I01N')
		endmethod
		
		public static method setCameraBoundsToMapForPlayer takes player user returns nothing
			call ResetCameraBoundsToMapRectForPlayer(user)
		endmethod

		/// Required by \ref Classes.
		public static method setCameraBoundsToPlayableAreaForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_playable)
		endmethod

		public static method setCameraBoundsToTavernForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_tavern_bounds)
		endmethod

		public static method setCameraBoundsToAosForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_aos)
		endmethod

		public static method setCameraBoundsToTombForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_tomb)
		endmethod
		
		public static method classRangeAbilityId takes Character character returns integer
			// dragon slayer
			if (GetUnitTypeId(character.unit()) == 'H01J') then
				return 'A16I'
			// cleric
			elseif (GetUnitTypeId(character.unit()) == 'H01L') then
				return 'A16J'
			// necromancer
			elseif (GetUnitTypeId(character.unit()) == 'H01N') then
				return 'A16K'
			// druid
			elseif (GetUnitTypeId(character.unit()) == 'H01P') then
				return 'A16L'
			// knight
			elseif (GetUnitTypeId(character.unit()) == 'H01R') then
				return 'A16M'
			// ranger
			elseif (GetUnitTypeId(character.unit()) == 'H01T') then
				return 'A16N'
			// elemental mage
			elseif (GetUnitTypeId(character.unit()) == 'H01V') then
				return 'A16O'
			// wizard
			elseif (GetUnitTypeId(character.unit()) == 'H01X') then
				return 'A16P'
			endif
			return Classes.classRangeAbilityId(character.class())
		endmethod
		
		public static method classMeleeAbilityId takes Character character returns integer
			// dragon slayer
			if (GetUnitTypeId(character.unit()) == 'H01K') then
				return 'A16H'
			// cleric
			elseif (GetUnitTypeId(character.unit()) == 'H01M') then
				return 'A16S'
			// necromancer
			elseif (GetUnitTypeId(character.unit()) == 'H01O') then
				return 'A16T'
			// druid
			elseif (GetUnitTypeId(character.unit()) == 'H01Q') then
				return 'A16Q'
			// knight
			elseif (GetUnitTypeId(character.unit()) == 'H01S') then
				return 'A16U'
			// ranger
			elseif (GetUnitTypeId(character.unit()) == 'H01U') then
				return 'A16V'
			// elemental mage
			elseif (GetUnitTypeId(character.unit()) == 'H01W') then
				return 'A16R'
			// wizard
			elseif (GetUnitTypeId(character.unit()) == 'H01Y') then
				return 'A16W'
			endif
			return Classes.classMeleeAbilityId(character.class())
		endmethod

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player user returns nothing
			if (Aos.areaContainsCharacter.evaluate(ACharacter.playerCharacter(user))) then
				call thistype.setCameraBoundsToAosForPlayer(user)
			elseif (Tomb.areaContainsCharacter.evaluate(ACharacter.playerCharacter(user))) then
				call thistype.setCameraBoundsToTombForPlayer(user)
			elseif (false) then /// @todo Tavern area
				call thistype.setCameraBoundsToTavernForPlayer(user)
			else
				call thistype.setCameraBoundsToPlayableAreaForPlayer(user)
			endif
		endmethod

static if (DEBUG_MODE) then
		private static method onCheatActionMapCheats takes ACheat cheat returns nothing
			call Print(tr("Örtlichkeiten-Cheats:"))
			call Print("bonus")
			call Print("start")
			call Print("castle")
			call Print("talras")
			call Print("farm")
			call Print("forest")
			call Print("aos")
			call Print("aosentry")
			call Print("tavern")
			call Print(tr("Video-Cheats:"))
			call Print("intro")
			call Print("rescuedago0")
			call Print("rescuedago1")
			call Print("thecastle")
			call Print("thedukeoftalras")
			call Print("thechief")
			call Print("thefirstcombat")
			call Print("wigberht")
			call Print("anewalliance")
			call Print("upstream")
			call Print("dragonhunt")
			call Print("deathvault")
			call Print("bloodthirstiness")
			call Print("deranor")
			call Print("deranorsdeath")
			call Print("recruitthehighelf")
			call Print(tr("Handlungs-Cheats:"))
			call Print("aftertalras")
			call Print("afterthenorsemen")
			call Print("afterslaughter")
			call Print("afterderanor")
			call Print("afterthebattle")
			call Print(tr("Erzeugungs-Cheats:"))
			call Print("unitspawns")
			call Print("testspawnpoint")
		endmethod
		
		private static method onCheatActionBonus takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_bonus)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call SetCameraBoundsToRectForPlayerBJ(whichPlayer, gg_rct_bonus)
			set whichPlayer = null
		endmethod

		private static method onCheatActionStart takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_start)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCamp takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCastle takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_castle)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionTalras takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_talras)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionFarm takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_farm)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionForest takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_forest)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAos takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_shrine_baldar_discover)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAosEntry takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_aos_outside)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod
		
		private static method onCheatActionTavern takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_area_tavern_bounds)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionIntro takes ACheat cheat returns nothing
			call VideoIntro.video().play()
		endmethod

		private static method onCheatActionRescueDago0 takes ACheat cheat returns nothing
			call VideoRescueDago0.video().play()
		endmethod

		private static method onCheatActionRescueDago1 takes ACheat cheat returns nothing
			call VideoRescueDago1.video().play()
		endmethod

		private static method onCheatActionTheCastle takes ACheat cheat returns nothing
			call VideoTheCastle.video().play()
		endmethod

		private static method onCheatActionTheDukeOfTalras takes ACheat cheat returns nothing
			call VideoTheDukeOfTalras.video().play()
		endmethod

		private static method onCheatActionTheChief takes ACheat cheat returns nothing
			call VideoTheChief.video().play()
		endmethod

		private static method onCheatActionTheFirstCombat takes ACheat cheat returns nothing
			call VideoTheFirstCombat.video().play()
		endmethod

		private static method onCheatActionWigberht takes ACheat cheat returns nothing
			call VideoWigberht.video().play()
		endmethod

		private static method onCheatActionANewAlliance takes ACheat cheat returns nothing
			call VideoANewAlliance.video().play()
		endmethod

		private static method onCheatActionUpstream takes ACheat cheat returns nothing
			call VideoUpstream.video().play()
		endmethod

		private static method onCheatActionDragonHunt takes ACheat cheat returns nothing
			call VideoDragonHunt.video().play()
		endmethod

		private static method onCheatActionDeathVault takes ACheat cheat returns nothing
			call VideoDeathVault.video().play()
		endmethod

		private static method onCheatActionBloodthirstiness takes ACheat cheat returns nothing
			call VideoBloodthirstiness.video().play()
		endmethod
		
		private static method onCheatActionDeranor takes ACheat cheat returns nothing
			call VideoDeranor.video().play()
		endmethod
		
		private static method onCheatActionDeranorsDeath takes ACheat cheat returns nothing
			call VideoDeranorsDeath.video().play()
		endmethod
		
		private static method onCheatActionRecruitTheHighElf takes ACheat cheat returns nothing
			call VideoRecruitTheHighElf.video().play()
		endmethod
		
		private static method moveCharactersToRect takes rect whichRect returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SetUnitX(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterX(whichRect))
					call SetUnitY(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterY(whichRect))
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method makeCharactersInvulnerable takes boolean invulnerable returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SetUnitInvulnerable(ACharacter.playerCharacter(Player(i)).unit(), invulnerable)
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method onCheatActionAfterTalras takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest.evaluate().isCompleted()) then
				if (not QuestTalras.quest.evaluate().isNew()) then
					debug call Print("New quest Talras")
					if (not QuestTalras.quest.evaluate().enable()) then
						debug call Print("Failed enabling quest Talras")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTalras.quest.evaluate().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
					debug call Print("Complete quest item 0 Talras")
					/*
					 * Plays video "The Castle".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_0)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					if (not  QuestTalras.quest.evaluate().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
						debug call Print("Failed completing quest item meet at reach the castle.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTalras.quest.evaluate().questItem(QuestTalras.questItemMeetHeimrich).isCompleted()) then
					debug call Print("Complete quest item 1 Talras")
					/*
					 * Plays video "The Duke of Talras".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterTheNorsemen takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest().isCompleted()) then
				debug call Print("Quest Talras must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			/*
			 * Quest The Norsemen must be at least new now.
			 */
			if (not QuestTheNorsemen.quest.evaluate().isCompleted()) then
				if (not QuestTheNorsemen.quest.evaluate().isNew()) then
					if (not QuestTheNorsemen.quest.evaluate().enable()) then
						debug call Print("Failed enabling quest The Norsemen")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				if (not QuestTheNorsemen.quest.evaluate().questItem.evaluate(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
					/*
					 * Plays video "The Chief".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_quest_item_0)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					if (not  QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
						debug call Print("Failed completing quest item meet at the norsemen.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
					/*
					 * Plays video "The First combat".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_assembly_point)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					if (not  QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
						debug call Print("Failed completing quest item meet at the battlefield.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemFight).isCompleted()) then
					/*
					 * Plays video "Wigberht".
					 */
					/*
					 * TODO cleanup does not work! Remove fighting troops, disable leaderboard etc.
					 * TODO Does not change the state!
					 */
					if (QuestTheNorsemen.quest.evaluate().completeFight()) then
						call TriggerSleepAction(AVideo.waitTime() + 2.0)
						call waitForVideo(MapData.videoWaitInterval)
						call TriggerSleepAction(AVideo.waitTime() + 2.0)
					else
						debug call Print("Failed completing quest item fight.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemReportHeimrich).isCompleted()) then
					/*
					 * Plays video "A new alliance"
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterSlaughter takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestSlaughter.quest().isCompleted()) then
				if (not QuestSlaughter.quest().isNew()) then
					if (not QuestSlaughter.quest().enable()) then
						debug call Print("Enabling quest Slaughter failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				// TODO it would be safer to complete the single quest items
				call QuestSlaughter.quest().complete()
				call TriggerSleepAction(AVideo.waitTime() + 2.0)
				call waitForVideo(MapData.videoWaitInterval)
				call TriggerSleepAction(AVideo.waitTime() + 2.0)
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterDeranor takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			
			if (not QuestSlaughter.quest().isCompleted()) then
				debug call Print("Quest Slaughter must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			
			if (not QuestDeranor.quest().isCompleted()) then
				if (not QuestDeranor.quest().isNew()) then
					if (not QuestDeranor.quest().enable()) then
						debug call Print("Enabling quest Deranor failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
					/*
					 * Plays video "Deranor".
					 */
					call thistype.moveCharactersToRect(gg_rct_area_tomb)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
						debug call Print("Failed to complete enter the tomb.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
					/*
					 * Plays video "Deranor's Death".
					 */
					call KillUnit(gg_unit_u00A_0353)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(AVideo.waitTime() + 2.0)
					if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
						debug call Print("Failed to complete kill deranor.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		/**
		 * This cheat action tries to emulate that the battle with the norseman has been done and now the quest "A new alliance" is active.
		 * Therefore the following quests have been completed:
		 * Talras
		 * The Norsemen
		 * Slaughter
		 * Deranor
		 *
		 * All events which happened by these quests must be emulated.
		 */
		private static method onCheatActionAfterTheBattle takes ACheat cheat returns nothing
			call thistype.onCheatActionAfterTalras(cheat)
			call thistype.onCheatActionAfterTheNorsemen(cheat)
			call thistype.onCheatActionAfterSlaughter(cheat)
			call thistype.onCheatActionAfterDeranor(cheat)
		endmethod

		private static method onCheatActionUnitSpawn takes ACheat cheat returns nothing
			call UnitTypes.spawn(GetTriggerPlayer(), GetUnitX(Character.playerCharacter(GetTriggerPlayer()).unit()), GetUnitY(Character.playerCharacter(GetTriggerPlayer()).unit()))
		endmethod
		
		private static method onCheatActionTestSpawnPoint takes ACheat cheat returns nothing
			call TestSpawnPoint.spawn()
		endmethod
		
		private static method createCheats takes nothing returns nothing
			local ACheat cheat
			debug call Print(tr("|c00ffcc00TEST-MODUS|r"))
			debug call Print(tr("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"mapcheats\", um eine Liste sämtlicher Karten-Cheats zu erhalten."))
			debug call Print("Before creating \"mapcheats\"")
			set cheat = ACheat.create("mapcheats", true, thistype.onCheatActionMapCheats)
			debug call Print("After creating \"mapcheats\": " + I2S(cheat))
			call ACheat.create("bonus", true, thistype.onCheatActionBonus)
			call ACheat.create("start", true, thistype.onCheatActionStart)
			call ACheat.create("camp", true, thistype.onCheatActionCamp)
			call ACheat.create("castle", true, thistype.onCheatActionCastle)
			call ACheat.create("talras", true, thistype.onCheatActionTalras)
			call ACheat.create("farm", true, thistype.onCheatActionFarm)
			call ACheat.create("forest", true, thistype.onCheatActionForest)
			call ACheat.create("aos", true, thistype.onCheatActionAos)
			call ACheat.create("aosentry", true, thistype.onCheatActionAosEntry)
			call ACheat.create("tavern", true, thistype.onCheatActionTavern)
			// videos
			call ACheat.create("intro", true, thistype.onCheatActionIntro)
			call ACheat.create("rescuedago0", true, thistype.onCheatActionRescueDago0)
			call ACheat.create("rescuedago1", true, thistype.onCheatActionRescueDago1)
			call ACheat.create("thecastle", true, thistype.onCheatActionTheCastle)
			call ACheat.create("thedukeoftalras", true, thistype.onCheatActionTheDukeOfTalras)
			call ACheat.create("thechief", true, thistype.onCheatActionTheChief)
			call ACheat.create("thefirstcombat", true, thistype.onCheatActionTheFirstCombat)
			call ACheat.create("wigberht", true, thistype.onCheatActionWigberht)
			call ACheat.create("anewalliance", true, thistype.onCheatActionANewAlliance)
			call ACheat.create("upstream", true, thistype.onCheatActionUpstream)
			call ACheat.create("dragonhunt", true, thistype.onCheatActionDragonHunt)
			call ACheat.create("deathvault", true, thistype.onCheatActionDeathVault)
			call ACheat.create("bloodthirstiness", true, thistype.onCheatActionBloodthirstiness)
			call ACheat.create("deranor", true, thistype.onCheatActionDeranor)
			call ACheat.create("deranorsdeath", true, thistype.onCheatActionDeranorsDeath)
			call ACheat.create("recruitthehighelf", true, thistype.onCheatActionRecruitTheHighElf)
			// plot cheats
			call ACheat.create("aftertalras", true, thistype.onCheatActionAfterTalras)
			call ACheat.create("afterthenorsemen", true, thistype.onCheatActionAfterTheNorsemen)
			call ACheat.create("afterslaughter", true, thistype.onCheatActionAfterSlaughter)
			call ACheat.create("afterderanor", true, thistype.onCheatActionAfterDeranor)
			call ACheat.create("afterthebattle", true, thistype.onCheatActionAfterTheBattle)
			// test cheats
			call ACheat.create("unitspawn", true, thistype.onCheatActionUnitSpawn)
			call ACheat.create("testspawnpoint", true, thistype.onCheatActionTestSpawnPoint)
			debug call Print("Before creating all cheats")
		endmethod
endif

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i
			call initMapPrimaryQuests()
			call initMapSecundaryQuests()
			
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				call initMapCharacterSpells.evaluate(ACharacter.playerCharacter(Player(i)))
				call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				set i = i + 1
			endloop
			
			call VideoIntro.video().play()
		endmethod
		
		private static method applyHandicap takes nothing returns nothing
			local integer missingPlayers =  Game.missingPlayers()
			local real handicap = 1.0 - missingPlayers * 0.05
			// decrease difficulty for others if players are missing
			if (handicap > 0.0) then
				call SetPlayerHandicap(Player(PLAYER_NEUTRAL_AGGRESSIVE), handicap)
				call TriggerSleepAction(4.0)
				call Character.displayDifficultyToAll(Format(tr("Da Sie das Spiel ohne %1% Spieler beginnen, erhalten die Gegner ein Handicap von %2% %. Zudem erhält Ihr Charakter sowohl mehr Erfahrungspunkte als auch mehr Goldmünzen beim Töten von Gegnern.")).s(trp("einen weiteren", Format("%1% weitere").i(missingPlayers).result(), missingPlayers)).rw(handicap * 100.0, 0, 0).result())
			endif
		endmethod
		
		/**
		 * This method should be called after the intro has been shown.
		 * It uses a boolean variable to make sure it is only called once in case the video "Intro" is run via a cheat
		 * multiple times.
		 *
		 * The function enables the main quest "Talras", starts NPC routines and adds start items to characters.
		 *
		 * It is called in the onStopAction() of the video intro with .evaluate() which means it is called after unpausing all units and restoring all player data.
		 */
		public static method startAfterIntro takes nothing returns nothing
			// call the following code only once in case the intro is showed multiple times
			if (thistype.m_startedGameAfterIntro) then
				return
			endif
			set thistype.m_startedGameAfterIntro = true
			
			debug call Print("Waited successfully for intro video.")

			debug call thistype.createCheats()
			
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Drücken Sie die Escape-Taste, um ins Haupt-Menü zu gelangen."))
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)
			call QuestTalras.quest().enable()

			call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called
			
			// execute because of trigger sleep action
			call thistype.applyHandicap.execute()
		endmethod

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			debug if (index < 0 or index >= thistype.maxPlayers) then
				debug call thistype.staticPrint("Error: Invalid start X index.")
			debug endif
			if (index == 0) then
				return GetRectCenterX(gg_rct_character_0_start)
			elseif (index == 1) then
				return GetRectCenterX(gg_rct_character_1_start)
			elseif (index == 2) then
				return GetRectCenterX(gg_rct_character_2_start)
			elseif (index == 3) then
				return GetRectCenterX(gg_rct_character_3_start)
			elseif (index == 4) then
				return GetRectCenterX(gg_rct_character_4_start)
			elseif (index == 5) then
				return GetRectCenterX(gg_rct_character_5_start)
			endif
			return 0.0
		endmethod

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			debug if (index < 0 or index >= thistype.maxPlayers) then
				debug call thistype.staticPrint("Error: Invalid start Y index.")
			debug endif
			if (index == 0) then
				return GetRectCenterY(gg_rct_character_0_start)
			elseif (index == 1) then
				return GetRectCenterY(gg_rct_character_1_start)
			elseif (index == 2) then
				return GetRectCenterY(gg_rct_character_2_start)
			elseif (index == 3) then
				return GetRectCenterY(gg_rct_character_3_start)
			elseif (index == 4) then
				return GetRectCenterY(gg_rct_character_4_start)
			elseif (index == 5) then
				return GetRectCenterY(gg_rct_character_5_start)
			endif
			return 0.0
		endmethod
		
		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE) or whichPlayer == thistype.orcPlayer
		endmethod
	endstruct

endlibrary