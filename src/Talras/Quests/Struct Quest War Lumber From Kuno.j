library StructMapQuestsQuestWarLumberFromKuno requires Asl, StructGameQuestArea, StructMapQuestsQuestWarSubQuest, StructMapVideosVideoKuno

	struct QuestAreaWarKuno extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoKuno.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarReportKuno extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoReportKuno.video().play()
		endmethod
	endstruct
	
	struct QuestWarLumberFromKuno extends QuestWarSubQuest
		public static constant integer questItemLumberFromKuno = 0
		public static constant integer questItemKillTheWitches = 1
		public static constant integer questItemReportKuno = 2
		public static constant integer questItemMoveKunosLumberToTheCamp = 3
		
		private QuestAreaWarKuno m_questAreaKuno
		private QuestAreaWarReportKuno m_questAreaReportKuno
		
		/*
		 * Kuno
		 */
		public static constant integer witchSpawnPoints = 4
		private boolean array m_killedWitches[thistype.witchSpawnPoints]
		private timer m_kunosCartSpawnTimer
		private unit m_kunosCart
		
		implement Quest
		
		public method cleanUnits takes nothing returns nothing
			// Kuno
			call RemoveUnit(this.m_kunosCart)
			set this.m_kunosCart = null
		endmethod
		
		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateNew)
			
			set this.m_questAreaKuno = QuestAreaWarKuno.create(gg_rct_quest_war_kuno)
			
			return result
		endmethod
		
		public method enableKillTheWitches takes nothing returns nothing
			call this.questItem(thistype.questItemKillTheWitches).setState(thistype.stateNew)
			call this.displayUpdate()
		endmethod
		
		private static method stateEventCompletedKillTheWitches takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		/**
		 * There is four spawn points for Witches at the moment.
		 * Both have to be checked for all units being dead.
		 * If so the quest item will be completed.
		 * The ping is always moved to the next living Witch.
		 *
		 * Once a spawn point has been cleared it needn't to be cleaned again. Otherwise characters would be running around trying to kill all Witches at the same time.
		 */
		private static method stateConditionCompletedKillTheWitches takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count0 = 0
			local integer count1 = 0
			local integer count2 = 0
			local integer count3 = 0
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.witch) then
				if (not this.m_killedWitches[0]) then
					set count0 = SpawnPoints.witch0().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[0] = count0 == 0
				endif
				if (not this.m_killedWitches[1]) then
					set count1 = SpawnPoints.witch1().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[1] = count1 == 0
				endif
				if (not this.m_killedWitches[2]) then
					set count2 = SpawnPoints.witch2().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[2] = count2 == 0
				endif
				if (not this.m_killedWitches[3]) then
					set count3 = SpawnPoints.witches().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[3] = count3 == 0
				endif
				if (this.m_killedWitches[0] and this.m_killedWitches[1] and this.m_killedWitches[2] and this.m_killedWitches[3]) then
					return true
				// get next one to ping
				else
					call this.displayUpdateMessage(Format(tre("%1%/6 Waldfurien", "%1%/6 Forest Furies")).i(6 - count0 - count1 - count2 - count3).result())
					if (count0 > 0) then
						call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.witch0(), UnitTypes.witch)
					elseif (count1 > 0) then
						call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.witch1(), UnitTypes.witch)
					elseif (count2 > 0) then
						call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.witch2(), UnitTypes.witch)
					else
						call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.witches(), UnitTypes.witch)
					endif
				endif
			endif
			return false
		endmethod
		
		/**
		 * After the Witches have been killed the characters must report Kuno.
		 * The same rect is used as for talking to him in the first place.
		 */
		private static method stateActionCompletedKillTheWitches takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(thistype.questItemReportKuno).setState(thistype.stateNew)
			call this.displayUpdate()
			set this.m_questAreaReportKuno = QuestAreaWarReportKuno.create(gg_rct_quest_war_kuno)
		endmethod
		
		private static method timerFunctionSpawnKunosCart takes nothing returns nothing
			local thistype this = thistype.quest()
			if (IsUnitDeadBJ(this.m_kunosCart)) then
				set this.m_kunosCart = CreateUnit(MapData.alliedPlayer, 'h021', GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 0.0)
				call this.displayUpdateMessage(tre("Eine neue Holzlieferung steht zur Verfügung.", "A new supply of wood is available."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 5.0, 255, 255, 255, true)
				
				call Game.setAlliedPlayerAlliedToAllCharacters()
			endif
		endmethod
		
		/**
		 * Kuno gives the characters a cart with lumber.
		 * It is owned by \ref MapData.alliedPlayer and has to be moved to the camp.
		 * Whenever it is killed a new one spawns at Kuno's house.
		 * It is checked periodically if it is killed.
		 */
		public method enableMoveKunosLumberToTheCamp takes nothing returns nothing
			call this.questItem(thistype.questItemReportKuno).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMoveKunosLumberToTheCamp).setState(thistype.stateNew)
			call this.displayUpdate()
			
			// TODO enable respawn timer
			set this.m_kunosCart = CreateUnit(MapData.alliedPlayer, 'h021', GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 0.0)
			set this.m_kunosCartSpawnTimer = CreateTimer()
			call TimerStart(this.m_kunosCartSpawnTimer, QuestWar.respawnTime, true, function thistype.timerFunctionSpawnKunosCart)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call QuestWar.quest.evaluate().enableCartDestination.evaluate()
		endmethod
		
		public method moveLumberCartToCamp takes nothing returns nothing
			call thistype.timerFunctionSpawnKunosCart()
			call SetUnitX(this.m_kunosCart, GetRectCenterX(gg_rct_quest_war_cart_destination))
			call SetUnitY(this.m_kunosCart, GetRectCenterY(gg_rct_quest_war_cart_destination))
		endmethod
		
		private static method stateEventCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod
		
		private static method stateConditionCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem returns boolean
			local thistype this = thistype.quest()
			return GetTriggerUnit() == this.m_kunosCart
		endmethod
		
		private static method stateActionCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem returns nothing
			local thistype this = thistype.quest()
			call QuestWar.quest.evaluate().setupUnitAtDestination.evaluate(this.m_kunosCart)
			call PauseTimer(this.m_kunosCartSpawnTimer)
			call DestroyTimer(this.m_kunosCartSpawnTimer)
			set this.m_kunosCartSpawnTimer = null
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateCompleted)
			call this.displayUpdate()
		endmethod
		
		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Holz von Kuno", "Lumber from Kuno"), QuestWar.questItemLumberFromKuno)
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)
			
			set questItem = AQuestItem.create(this, tre("Besorgt Holz vom Holzfäller Kuno.", "Get wood from the lumberjack Kuno."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemKillTheWitches
			set questItem = AQuestItem.create(this, tre("Vernichtet die Waldfurien.", "Destroy the Forest Furies."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedKillTheWitches)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedKillTheWitches)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedKillTheWitches)
			
			// quest item questItemReportKuno
			set questItem = AQuestItem.create(this, tre("Berichte Kuno davon.", "Report Kuno about it."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemMoveKunosLumberToTheCamp
			set questItem = AQuestItem.create(this, tre("Bringt Kunos Holz sicher zum Außenposten.", "Move Kuno's wood safely to the outpost."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedMoveKunosLumberToTheCamp)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedMoveKunosLumberToTheCamp)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedMoveKunosLumberToTheCamp)
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			return this
		endmethod
	endstruct
	
endlibrary