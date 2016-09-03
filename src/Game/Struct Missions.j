library StructGameMissions requires Asl, StructGameCharacter

	function PanToQuestForPlayer takes player whichPlayer, AQuest whichQuest returns nothing
		debug call Print("Pinging mission " + whichQuest.title())
		call SmartCameraPanWithZForPlayer(whichPlayer, whichQuest.latestPingX(), whichQuest.latestPingY(), 0.0, 0.0)
	endfunction

	private struct MissionEntry extends AMultipageSpellbookAction
		private AQuest m_quest

		public method missions takes nothing returns Missions
			return Missions(this.multipageSpellbook())
		endmethod

		public method quest takes nothing returns AQuest
			return this.m_quest
		endmethod

		public stub method onCheck takes nothing returns boolean
			if (not this.quest().isNew()) then
				call this.missions().character.evaluate().displayMessage(ACharacter.messageTypeError, tre("Auftrag wurde bereits abgeschlossen.", "Mission has already been completed."))

				return false
			endif

			return true
		endmethod

		public stub method onTrigger takes nothing returns nothing
			call PanToQuestForPlayer(this.missions().character.evaluate().player(), this.quest())
		endmethod

		public static method create takes Missions missions, integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns thistype
			local thistype this = thistype.allocate(missions, abilityId, spellBookAbilityId)
			set this.m_quest = whichQuest

			return this
		endmethod
	endstruct

	/**
	 * \brief Every character gets an item with a spellbook ability which contains icons for all active missions. Clicking on an icon pans the camera to the mission's target location.
	 */
	struct Missions extends AMultipageSpellbook
		private Character m_character
		private trigger m_pickupTrigger

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method addMission takes integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns integer
			return this.addEntry(MissionEntry.create(this, abilityId, spellBookAbilityId, whichQuest))
		endmethod

		private static method triggerConditionPickup takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			return GetItemTypeId(GetManipulatedItem()) == 'I061'
		endmethod

		private static method triggerActionPickup takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			debug call Print("Picked up missions book and updating UI")
			call this.updateUi()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character.unit(), 'A1RH', 'A1RJ', 'A1RC', 'A1RI')
			set this.m_character = character
			set this.m_pickupTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_pickupTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
			call TriggerAddCondition(this.m_pickupTrigger, Condition(function thistype.triggerConditionPickup))
			call TriggerAddAction(this.m_pickupTrigger, function thistype.triggerActionPickup)
			call DmdfHashTable.global().setHandleInteger(this.m_pickupTrigger, 0, this)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_pickupTrigger)
			set this.m_pickupTrigger = null
		endmethod

		public static method addMissionToAll takes integer abilityId, integer spellBookAbilityId, AQuest whichQuest returns nothing
			local Character character = 0
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set character = Character.playerCharacter(Player(i))
				if (character != 0) then
					call character.missions().addMission(abilityId, spellBookAbilityId, whichQuest)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary