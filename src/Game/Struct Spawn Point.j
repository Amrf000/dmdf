library StructGameSpawnPoint requires Asl

	/**
	 * \brief Spawn point with the default values of DMdF.
	 * Spawn points have to be stored in a static list since they must be paused in a video.
	 * \sa ItemSpawnPoint
	 */
	struct SpawnPoint extends ASpawnPoint
		public static constant real respawnTime = 45.0
		private static AIntegerList m_spawnPoints
	
		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setTime(thistype.respawnTime)
			call this.setEffectFilePath("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
			call this.setSoundFilePath("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerMorph.wav")
			call this.setDropChance(70)
			call this.setDistributeItems(true)
			call this.setOwner(Player(PLAYER_NEUTRAL_AGGRESSIVE))
			call this.setTextDistributeItem( tr("%s wurde für Spieler %s fallen gelassen."))
			
			call thistype.m_spawnPoints.pushBack(this)
	
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call thistype.m_spawnPoints.remove(this)
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_spawnPoints = AIntegerList.create()
		endmethod
		
		public static method pauseAll takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.m_spawnPoints.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).pause()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
		
		public static method resumeAll takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.m_spawnPoints.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).resume()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct
	
	/**
	 * \brief A spawn point for items which uses a uniform respawn time per spawn point of \ref respawnTime.
	 * Like \ref SpawnPoint it allows global storage of all item spawn points and pausing as well resuming durion video sequences.
	 * \sa SpawnPoint
	 */
	struct ItemSpawnPoint extends AItemSpawnPoint
		public static constant real respawnTime = 20.0
		private static AIntegerList m_spawnPoints

		public static method create takes real x, real y, item whichItem returns thistype
			local thistype this = thistype.allocate(x, y, whichItem)
			call this.setTime(thistype.respawnTime)
			call this.setEffectFilePath("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl")
			call this.setSoundFilePath("Abilities\\Spells\\Orc\\EtherealForm\\SpiritWalkerMorph.wav")
			
			call thistype.m_spawnPoints.pushBack(this)

			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call thistype.m_spawnPoints.remove(this)
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_spawnPoints = AIntegerList.create()
		endmethod
		
		public static method pauseAll takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.m_spawnPoints.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).pause()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
		
		public static method resumeAll takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.m_spawnPoints.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).resume()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct

endlibrary