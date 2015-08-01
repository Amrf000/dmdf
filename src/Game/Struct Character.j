library StructGameCharacter requires Asl, StructGameDmdfHashTable

	struct Character extends ACharacter
		// dynamic members
		private boolean m_isInPvp
		private boolean m_showCharactersScheme
		private boolean m_showWorker
		// members
		private MainMenu m_mainMenu
static if (DMDF_CREDITS) then
		private Credits m_credits
endif
		private Grimoire m_grimoire
		private Tutorial m_tutorial
static if (DMDF_CHARACTER_STATS) then
		private CharacterStats m_characterStats
endif
static if (DMDF_INFO_LOG) then
		private InfoLog m_infoLog
endif
		private AIntegerVector m_classSpells /// Only \ref Spell instances not \ref ASpell instances!

		private trigger m_workerTrigger
		private unit m_worker
		private boolean m_isMorphed

		// dynamic members

		public method setIsInPvp takes boolean isInPvp returns nothing
			set this.m_isInPvp = isInPvp
		endmethod

		public method isInPvp takes nothing returns boolean
			return this.m_isInPvp
		endmethod

		public method setView takes boolean enabled returns nothing
			if (not enabled and this.view().enableAgain()) then
				call this.view().setEnableAgain(false)
				call this.view().disable()
				call ResetToGameCameraForPlayer(this.player(), 0.0)
			elseif (enabled and not this.view().enableAgain()) then
				call this.view().setEnableAgain(true)
				call this.view().enable()
			debug else
				debug call Print("Character: Error since view has already enabled state.")
			endif
		endmethod

		public method isViewEnabled takes nothing returns boolean
			return this.view().isEnabled()
		endmethod

		public method showCharactersScheme takes nothing returns boolean
			return this.m_showCharactersScheme
		endmethod

		public method setShowWorker takes boolean show returns nothing
			set this.m_showWorker = show
			call ShowUnit(this.m_worker, show)
		endmethod

		public method showWorker takes nothing returns boolean
			return this.m_showWorker
		endmethod

		// members

		public method mainMenu takes nothing returns MainMenu
			return this.m_mainMenu
		endmethod

		public method credits takes nothing returns Credits
static if (DMDF_CREDITS) then
			return this.m_credits
else
			return 0
endif
		endmethod

		public method grimoire takes nothing returns Grimoire
			return this.m_grimoire
		endmethod

		public method tutorial takes nothing returns Tutorial
			return this.m_tutorial
		endmethod

/// @todo static ifs do not prevent import of files, otherwise this wouldn't be required
		public method characterStats takes nothing returns CharacterStats
static if (DMDF_CHARACTER_STATS) then
			return this.m_characterStats
else
			return 0
endif
		endmethod

/// @todo static ifs do not prevent import of files, otherwise info log wouldn't require this method
		public method infoLog takes nothing returns InfoLog
static if (DMDF_INFO_LOG) then
			return this.m_infoLog
else
			return 0
endif
		endmethod
		
		public method addClassSpell takes Spell spell returns nothing
			call this.m_classSpells.pushBack(spell)
		endmethod
		
		/**
		 * Since \ref ACharacter.spells() contains all spells belonging to the character it includes non class spells such as
		 * "Grimoire" or "Add to Favorites". This container stores only class spells which should be listed in the grimoire for example.
		 */
		public method classSpells takes nothing returns AIntegerVector
			return this.m_classSpells
		endmethod

		/**
		* Shows characters scheme to characer's player if enabled.
		* \sa thistype#showCharactersScheme, thistype#setShowCharactersScheme, thistype#showCharactersSchemeToAll
		*/
		public method showCharactersSchemeToPlayer takes nothing returns nothing
			// is disabled in GUI
			if (not AGui.playerGui(this.player()).isShown()) then
				if (this.showCharactersScheme()) then
					call ACharactersScheme.showForPlayer(this.player())
					call MultiboardSuppressDisplayForPlayer(this.player(), false)
				else
					call ACharactersScheme.hideForPlayer(this.player())
				endif
			endif
		endmethod

		/**
		* Hides characters scheme for characer's player if enabled.
		* \sa thistype#showCharactersScheme, thistype#setShowCharactersScheme, thistype#showCharactersSchemeToAll
		*/
		public method hideCharactersSchemeForPlayer takes nothing returns nothing
			if (this.showCharactersScheme()) then
				call ACharactersScheme.hideForPlayer(this.player())
			endif
		endmethod

		public method setShowCharactersScheme takes boolean showCharactersScheme returns nothing
			set this.m_showCharactersScheme = showCharactersScheme
			call this.showCharactersSchemeToPlayer()
		endmethod
		
		/**
		 * \return Returns the stored hash table with ability id - level pairs (parent key - 0, child key - ability id, value - level).
		 * \sa Grimoire#spellLevels
		 */
		public method realSpellLevels takes nothing returns AHashTable
			return AHashTable(DmdfHashTable.global().handleInteger(this.unit(), "SpellLevels"))
		endmethod
		
		public method clearRealSpellLevels takes nothing returns boolean
			if (DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				call this.realSpellLevels().destroy()
				call DmdfHashTable.global().removeHandleInteger(this.unit(), "SpellLevels")
				
				return true
			endif
			
			return false
		endmethod
		
		/**
		 * Stores all grimoire spell levels for later restoration by \ref restoreRealSpellLevels().
		 * This has to be done for unit transformations since non permanent abilities get lost.
		 */
		public method updateRealSpellLevels takes nothing returns nothing
			call this.clearRealSpellLevels()
			call DmdfHashTable.global().setHandleInteger(this.unit(), "SpellLevels", this.grimoire().spellLevels.evaluate())
		endmethod
		
		public method restoreRealSpellLevels takes nothing returns boolean
			if (DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				call this.grimoire().readd.evaluate(this.realSpellLevels())
				
				return true
			endif
			
			return false
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		/**
		 * Usually on passive hero transformation the grimoire abilities get lost, so they must be readded.
		 */
		public method updateGrimoireAfterPassiveTransformation takes nothing returns nothing
			/*
			 * Now the spell levels have to be readded and the grimoire needs to be updated since all abilities are gone.
			 */
			call this.restoreRealSpellLevels()
			call this.clearRealSpellLevels()
			call this.grimoire().updateUi.evaluate()
		endmethod

		/**
		 * Restores spells and inventory of the character after he has been morphed into another creature with other abilities and without inventory.
		 * The spell levels has been stored in \ref realSpellLevels() while calling \ref morph().
		 * \note Has to be called just after the character's unit restores from morphing.
		 */
		public method restoreUnit takes boolean disableInventory returns boolean
			if (not DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				debug call Print("Has not been morphed before!")
				return false
			endif
			
			if (disableInventory) then
				debug call Print("Enabling inventory again")
				call this.inventory().setEnableAgain(true)
				call this.inventory().enable()
			endif
			
			call this.updateGrimoireAfterPassiveTransformation()
			
			set this.m_isMorphed = false
			
			return true
		endmethod

		/**
		* When a character morphes there has to be some remorph functionality e. g. when the character dies and is being revived.
		* Besides he has to be restored when unmorphing (\ref Character#restoreUnit).
		* \note Has to be called just before the character's unit morphes.
		* \param abilityId Id of the ability which has to be casted to morph the character.
		*/
		public method morph takes boolean disableInventory returns boolean
			debug if (GetUnitAbilityLevel(this.unit(), 'AInv') == 0) then
			debug call Print("It is too late to store the items! Add a delay for the morphing ability!")
			debug endif
			
			call this.updateRealSpellLevels()
			
			// Make sure it won't be enabled again when the character is set movable.
			if (disableInventory) then
				/*
				 * Make sure it is a melee character before it morphes since all morph spells are based on melee characters.
				 * Otherwise one would have to create morph abilities for range and melee characters.
				 */
				call UnitAddAbility(this.unit(), MapData.classMeleeAbilityId.evaluate(this))
				call UnitRemoveAbility(this.unit(), MapData.classMeleeAbilityId.evaluate(this))
			
				call this.inventory().setEnableAgain(false)
				debug call Print("Disabling inventory")
				// Should remove but store all items and their permanently added abilities if the rucksack is open!
				call this.inventory().disable()
				debug call Print("After disabling inventory")
			endif
			
			set this.m_isMorphed = true
			
			return true
		endmethod

		private method displayQuestMessage takes integer messageType, string message returns nothing
			local force whichForce = GetForceOfPlayer(this.player())
			call QuestMessageBJ(whichForce, messageType, message)
			call DestroyForce(whichForce)
			set whichForce = null
		endmethod

		public method displayHint takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00TIPP|r - %1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayUnitAcquired takes string unitName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_UNITACQUIRED, Format(tr("|cff87ceebNEUE EINHEIT ERHALTEN|r\n%1% - %2%")).s(unitName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayItemAcquired takes string itemName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_ITEMACQUIRED, Format(tr("|cff87ceebNEUEN GEGENSTAND ERHALTEN|r\n%1% - %2%")).s(itemName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayAbilityAcquired takes string abilityName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff87ceebNEUE FÄHIGKEIT ERHALTEN|r\n%1% - %2%")).s(abilityName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		/// \todo How to display/format warnings?
		public method displayWarning takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_WARNING, Format(tr("%1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questWarningSound)
		endmethod

		public method displayDifficulty takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00SCHWIERIGKEITSGRAD|r - %1%")).s(message).result())
		endmethod

		public method displayFinalLevel takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00LETZTE STUFE|r - %1%")).s(message).result())
		endmethod

		public method displayFinalLevelToAllOthers takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0 and i != GetPlayerId(this.player())) then
					call thistype(thistype.playerCharacter(Player(i))).displayFinalLevel(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public method displayXPBonus takes integer xp, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff87ceebERFAHRUNGSBONUS ERHALTEN\n%1% - %2%")).i(xp).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method xpBonus takes integer xp, string message returns nothing
			call this.displayXPBonus(xp, message)
			call this.addExperience(xp, true)
		endmethod

		public method giveItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPlayer(whichItem, this.player(), true)
			// make sure it is put into the rucksack if possible and that it works even if the character is morphed and has no inventory ability.
			call this.inventory().addItem(whichItem)
			//call UnitAddItem(this.unit(), whichItem)
		endmethod

		/**
		 * Makes item invulnerable, changes its owner to owner of character, makes it unpawnable and gives it to the character automatically.
		 */
		public method giveQuestItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPawnable(whichItem, false)
			call SetItemInvulnerable(whichItem, true)
			call SetItemPlayer(whichItem, this.player(), true)
			// make sure it is put into the rucksack if possible and that it works even if the character is morphed and has no inventory ability.
			call this.inventory().addItem(whichItem)
			//call UnitAddItem(this.unit(), whichItem)
		endmethod

		private static method triggerConditionWorker takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerPlayer() == this.player() and ACharacter.playerCharacter(GetTriggerPlayer()).shrine() != 0
		endmethod

		private static method triggerActionWorker takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			//call ACharacter.playerCharacter(GetTriggerPlayer()).select()
			call SmartCameraPanWithZForPlayer(this.player(), GetDestructableX(this.shrine().destructable()), GetDestructableY(this.shrine().destructable()), 0.0, 0.0)
			call SelectUnitForPlayerSingle(this.unit(), this.player())
			debug call Print("Selected worker")
		endmethod

		private method createWorkerTrigger takes nothing returns nothing
			set this.m_worker = CreateUnit(this.player(), MapData.workerUnitTypeId, GetRectCenterX(gg_rct_worker), GetRectCenterY(gg_rct_worker), 0.0)
			// Do not hide and pause!
			//call PauseUnit(this.m_worker, true)
			call SetUnitInvulnerable(this.m_worker, true)
			call SetUnitPathing(this.m_worker, false)
			//call ShowUnit(this.m_worker, false)
			set this.m_workerTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_workerTrigger, this.m_worker, EVENT_UNIT_SELECTED)
			call TriggerAddCondition(this.m_workerTrigger, Condition(function thistype.triggerConditionWorker))
			call TriggerAddAction(this.m_workerTrigger, function thistype.triggerActionWorker)
			call DmdfHashTable.global().setHandleInteger(this.m_workerTrigger, "this", this)
		endmethod

		public static method create takes player whichPlayer, unit whichUnit returns thistype
			local thistype this = thistype.allocate(whichPlayer, whichUnit)
			// dynamic members
			set this.m_isInPvp = false
			set this.m_showCharactersScheme = false
			set this.m_showWorker = true
			// members
			set this.m_mainMenu = MainMenu.create.evaluate(this)
static if (DMDF_CREDITS) then
			set this.m_credits = Credits.create.evaluate(this)
endif
			set this.m_grimoire = Grimoire.create.evaluate(this)
			set this.m_tutorial = Tutorial.create.evaluate(this)
static if (DMDF_CHARACTER_STATS) then
			set this.m_characterStats = CharacterStats.create.evaluate(this)
endif
static if (DMDF_INFO_LOG) then
			set this.m_infoLog = InfoLog.create.evaluate(this)
endif

			set this.m_classSpells = AIntegerVector.create()
			call this.createWorkerTrigger()
			set this.m_isMorphed = false

			return this
		endmethod

		private method destroyWorkerTrigger takes nothing returns nothing
			call RemoveUnit(this.m_worker)
			set this.m_worker = null
			call DmdfHashTable.global().destroyTrigger(this.m_workerTrigger)
			set this.m_workerTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_mainMenu.destroy.evaluate()
static if (DMDF_CREDITS) then
			call this.m_grimoire.destroy.evaluate()
endif
			call this.m_tutorial.destroy.evaluate()
static if (DMDF_CHARACTER_STATS) then
			call this.m_characterStats.destroy.evaluate()
endif
static if (DMDF_INFO_LOG) then
			call this.m_infoLog.destroy.evaluate()
endif
			call this.m_classSpells.destroy()
			set this.m_classSpells = 0
			call this.destroyWorkerTrigger()
		endmethod

		/**
		* \sa thistype#showCharactersSchemeToPlayer
		*/
		public static method showCharactersSchemeToAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).showCharactersSchemeToPlayer()
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayHintToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayHint(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayUnitAcquiredToAll takes string unitName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayUnitAcquired(unitName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayItemAcquiredToAll takes string itemName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayItemAcquired(itemName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayAbilityAcquiredToAll takes string abilityName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayAbilityAcquired(abilityName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayWarningToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayWarning(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayDifficultyToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayDifficulty(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setViewForAll takes boolean enabled returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).setView(enabled)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setTutorialForAll takes boolean enabled returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).tutorial().setEnabled.evaluate(enabled)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method addSkillGrimoirePointsToAll takes integer skillPoints returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).grimoire().addSkillPoints.evaluate(skillPoints)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary