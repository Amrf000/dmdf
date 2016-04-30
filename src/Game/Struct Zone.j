library StructGameZone requires Asl, StructGameCharacter, StructGameQuestArea, StructGameMapChanger

	/**
	 * \brief Zones are used for map changes.
	 * Like in the Bonus Campaign these areas can be entered by all characters. When all characters have entered the rect the map is changed.
	 * In multiplayer of course this does not work so only the save code might be shown or nothing happens.
	 * In a campaign the map is changed and everything is stored in a gamecache. The game is saved before that the player can return to the original map.
	 */
	struct Zone extends QuestArea
		public static constant integer unitTypeId = 'n06N'
		private static AIntegerVector m_zones
		private string m_mapName
		private unit m_iconUnit
		private boolean m_isEnabled
		
		public static method zones takes nothing returns AIntegerVector
			return thistype.m_zones
		endmethod
		
		public method mapName takes nothing returns string
			return this.m_mapName
		endmethod
		
		public method enable takes nothing returns nothing
			set this.m_isEnabled = true
		endmethod
		
		public method disable takes nothing returns nothing
			set this.m_isEnabled = false
		endmethod
		
		public stub method onCheck takes nothing returns boolean
			if (not this.m_isEnabled) then
				call Character.displayHintToAll(tre("Dieser Kartenausgang kann noch nicht benutzt werden.", "This map exit cannot be used yet."))
			endif
			
			return this.m_isEnabled
		endmethod
		
		/**
		 * \note Is called with .execute().
		 */
		public stub method onStart takes nothing returns nothing
			call MapChanger.changeMap(this.mapName())
		endmethod
		
		public static method create takes string mapName, rect whichRect returns thistype
			local thistype this = thistype.allocate(whichRect)
			set this.m_mapName = mapName
			call this.setDestroyOnActivation(false)
			call thistype.m_zones.pushBack(this)
			set this.m_iconUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), 0.0)
			call SetUnitInvulnerable(this.m_iconUnit, true)
			call SetUnitPathing(this.m_iconUnit, false)
			call UnitSetUsesAltIcon(this.m_iconUnit, true)
			set this.m_isEnabled = true
			return this
		endmethod
		
		public static method onInit takes nothing returns nothing
			set thistype.m_zones = AIntegerVector.create()
			call SetAltMinimapIcon("UI\\Minimap\\MiniMap-Entrance.blp")
		endmethod
	endstruct
	
endlibrary