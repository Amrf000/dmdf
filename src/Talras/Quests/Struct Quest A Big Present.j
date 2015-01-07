library StructMapQuestsQuestABigPresent requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestABigPresent extends AQuest
		public static constant integer itemTypeId = 'I03X'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call Character(this.character()).giveQuestItem(thistype.itemTypeId)
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Ein großes Geschenk"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBarrel.blp")
			call this.setDescription(tr("Da Lothar mit Mathildas Reaktion auf sein Geschenk nicht zufrieden war, hat er dir nun aufgetragen, ihr einen noch größeren Honigtopf zu überreichen, um seiner Liebe zu ihr noch größeren Ausdruck zu verleihen."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tr("Überreiche Mathilda Lothars großen Honigtopf."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mathilda())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(AAbstractQuest.rewardExperience, 50)
			// item 1
			set questItem = AQuestItem.create(this, tr("Berichte Lothar davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.lothar())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary