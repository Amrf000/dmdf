library StructMapMapMapData requires Asl, Game, StructMapMapShrines, StructMapMapFellows, MapQuests

	struct MapData
		private static Zone m_zoneGardonar
		private static Zone m_zoneDeranorsSwamp

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("GH")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\War3XMainScreen.mp33")
			call MapSettings.setGoldmine(gg_unit_n06E_0090)
			call MapSettings.addZoneRestorePositionForAllPlayers("GA", GetRectCenterX(gg_rct_start), GetRectCenterY(gg_rct_start), 90.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("DS", GetRectCenterX(gg_rct_start_deranors_swamp), GetRectCenterY(gg_rct_start_deranors_swamp), 270.0)
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			call Shrines.init()
			call NewOpLimit(function SpawnPoints.init)
			call NewOpLimit(function Fellows.init) // init after talks (new)

			set thistype.m_zoneGardonar = Zone.create("WM", gg_rct_zone_gardonar)
			set thistype.m_zoneGardonar = Zone.create("GA", gg_rct_zone_gardonar)
			set thistype.m_zoneDeranorsSwamp = Zone.create("DS", gg_rct_zone_deranors_swamp)

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
			call Classes.createDefaultClassSelectionItems(class, whichUnit)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassItems takes Character character returns nothing
			call Classes.createDefaultClassItems(character)
		endmethod

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start))
			call SetUnitFacing(character.unit(), 90.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(true)
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop

			call initMapPrimaryQuests()
			call initMapSecundaryQuests()

			call SuspendTimeOfDay(false)

			call thistype.startAfterIntro.evaluate()
		endmethod

		public static method startAfterIntro takes nothing returns nothing
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
			call Fellows.dragonSlayer().shareWithAll()

			call QuestHell.quest().enable()

			//call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called

			call Game.applyHandicapToCreeps()
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
		endmethod

		public static method onInitVideoSettings takes nothing returns nothing
		endmethod

		public static method onResetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary