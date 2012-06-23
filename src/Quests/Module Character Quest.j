library ModuleQuestsCharacterQuest requires Asl

	module CharacterQuest
		private static thistype array m_characterQuest[6] /// @todo MapData.maxPlayers

		public static method initQuest takes nothing returns nothing
			local player user
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set user = Player(i)
				if (ACharacter.playerCharacter(user) != 0) then
					set thistype.m_characterQuest[i] = thistype.create.evaluate(ACharacter.playerCharacter(user))
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method characterQuest takes ACharacter character returns thistype
			local player whichPlayer = character.player()
			local integer playerId = GetPlayerId(whichPlayer)
			set whichPlayer = null
			return thistype.m_characterQuest[playerId]
		endmethod
	endmodule

endlibrary