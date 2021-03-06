library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	/**
	 * \brief Static struct which stores and initializes all NPC routines for specific NPCs/units.
	 */
	struct NpcRoutines
		private static ARoutine m_teleport

		private static NpcTalksRoutine m_motherTalksToGotlinde
		private static NpcRoutineWithFacing m_motherStands
		private static NpcHammerRoutine m_gotlindeWorks
		private static NpcTalksRoutine m_wotanPrays
		private static NpcTalksRoutine m_wotanHouse
		private static NpcTalksRoutine m_wotanPortal

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method teleportTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Attack")
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(period, thistype.teleportTargetAction)
		endmethod

		// NOTE take a look into struct Routines which ARoutinePeriod sub types you have to create and which parameters you could set for them!!!
		public static method init takes nothing returns nothing
			set thistype.m_teleport = ARoutine.create(true, true, 0, 0, 0, thistype.teleportTargetAction) // NOTE second true means loop that it returns to the position.

			set thistype.m_motherTalksToGotlinde = NpcTalksRoutine.create(Routines.talk(), Npcs.mother(), 0.00, 17.00, gg_rct_waypoint_mother)
			call thistype.m_motherTalksToGotlinde.setFacing(218.30)
			call thistype.m_motherTalksToGotlinde.setPartner(Npcs.gotlinde())
			call thistype.m_motherTalksToGotlinde.addSound(tre("Wie geht es dir?", "How are you?"), gg_snd_Mother01)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Gut.", "I'm fine."), gg_snd_Gotlinde3)
			call thistype.m_motherTalksToGotlinde.addSound(tre("Was macht die Arbeit?", "How is the work going?"), gg_snd_Mother12)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Na ja, es könnte besser laufen.", "Well, it could be going better."), gg_snd_Gotlinde4)
			call thistype.m_motherTalksToGotlinde.addSound(tre("Komm doch rein, trinke etwas und ruh dich aus.", "Come in, drink something and get some rest."), gg_snd_Mother13)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Danke, aber später vielleicht.", "Thank you, maybe later."), gg_snd_Gotlinde5)
			call thistype.m_motherTalksToGotlinde.addSound(tre("Wirst du ihn vermissen?", "Will you miss him?"), gg_snd_Mother14)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Ja, sehr sogar.", "Yes, very much."), gg_snd_Gotlinde6)
			call thistype.m_motherTalksToGotlinde.addSound(tre("Er ist eben schüchtern.", "He is just shy."), gg_snd_Mother15)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Ich weiß ...", "I know ..."), gg_snd_Gotlinde7)
			call thistype.m_motherTalksToGotlinde.addSound(tre("Und was ist mit Ralph? Der ist doch auch ein ganz netter Kerl.", "He is just And what about Ralph? He's a nice guy, too."), gg_snd_Mother16)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Bei den Göttern! Ralph?! Der schafft ja noch nicht einmal die Gartenarbeit alleine.", "By the goods! Ralph?! He does not even manage gardening alone."), gg_snd_Gotlinde8)

			set thistype.m_motherStands = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.mother(), 17.00, 23.59, gg_rct_waypoint_mother)
			call thistype.m_motherStands.setFacing(305.64)

			set thistype.m_gotlindeWorks = NpcHammerRoutine.create(Routines.hammer(), Npcs.gotlinde(), 17.00, 23.59, gg_rct_waypoint_gotlinde_smith)
			call thistype.m_gotlindeWorks.setFacing(108.32)
			call thistype.m_gotlindeWorks.setSound(gg_snd_BlacksmithWhat1)
			call thistype.m_gotlindeWorks.setSoundVolume(30.0)

			set thistype.m_wotanPrays = NpcTalksRoutine.create(Routines.talk(), Npcs.wotan(), 8.0, 23.0, gg_rct_waypoint_wotan_island)
			call thistype.m_wotanPrays.setFacing(262.95)
			call thistype.m_wotanPrays.setPartner(null)
			call thistype.m_wotanPrays.addSound(tre("Ich bin WOOOOOTAAAAAAN und herrsche über diese Insel!", "I am WOOOOOTAAAAAAN and reign over this island!"), gg_snd_Wotan13)
			call thistype.m_wotanPrays.addSound(tre("Nennt mich einen Gott!", "Call me a god!"), gg_snd_Wotan14)
			call thistype.m_wotanPrays.addSound(tre("Ich herrsche, ihr dient!", "I rule, you serve!"), gg_snd_Wotan15)

			set thistype.m_wotanHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.wotan(), 23.0, 4.0, gg_rct_waypoint_wotan_house)
			call thistype.m_wotanPortal.setFacing(297.03)

			set thistype.m_wotanPortal = NpcRoutineWithFacing.create(thistype.m_teleport, Npcs.wotan(), 4.0, 8.0, gg_rct_waypoint_wotan_portal)
			call thistype.m_wotanPortal.setFacing(297.03)
		endmethod
	endstruct

endlibrary