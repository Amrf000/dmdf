library StructMapTalksTalkTrommon requires Asl, StructGameClasses, StructMapQuestsQuestWoodForTheHut, StructMapQuestsQuestSeedsForTheGarden

	struct TalkTrommon extends ATalk
		private static constant integer goldCost = 10
		private boolean array m_hasPaid[6] /// @todo @member MapData.maxPlayers
		private boolean array m_wasOffended[6] /// @todo @member MapData.maxPlayers

		implement Talk

		public method hasPaid takes player whichPlayer returns boolean
			return this.m_hasPaid[GetPlayerId(whichPlayer)]
		endmethod

		private method pay takes player whichPlayer returns nothing
			set this.m_hasPaid[GetPlayerId(whichPlayer)] = true
		endmethod

		private method offend takes player whichPlayer returns nothing
			set this.m_wasOffended[GetPlayerId(whichPlayer)] = true
		endmethod

		private method wasOffended takes player whichPlayer returns boolean
			return this.m_wasOffended[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(10, character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo! Wer bist du und was treibt dich in diese Gegend?"), null)
			if (character.class() == Classes.cleric()) then
				call speech(info, character, false, tr("Der Glaube."), null)
				call speech(info, character, true, tr("Hmm, ein frommer Mann. Ich fühle mich geehrt auch wenn ich deinen Glauben wahrscheinlich nicht teile."), null)
			elseif (character.class() == Classes.necromancer()) then
				call speech(info, character, false, tr("Der Tod."), null)
				call speech(info, character, true, tr("Das sind aber finstere Worte mein Freund. Hier, nimm dir einen Apfel, dann geht’s dir schon viel besser."), null)
			elseif (character.class() == Classes.druid()) then
				call speech(info, character, false, tr("Die Natur."), null)
				call speech(info, character, true, tr("Das kann ich verstehen. Ein Grund weshalb ich hier draußen lebe."), null)
				call speech(info, character, true, tr("Hier hast du einen Apfel."), null)
				// Charakter erhält einen Apfel
				call character.giveItem('I03O')
			elseif (character.class() == Classes.astralModifier()) then
				call speech(info, character, false, tr("Die Geister."), null)
				call speech(info, character, true, tr("Klingt beängstigend. Na ja, wer weiß schon, was sich hier in dieser Gegend so rumtreibt."), null)
			elseif (character.class() == Classes.knight()) then
				call speech(info, character, false, tr("Die Pflicht."), null)
				call speech(info, character, true, tr("So so, du bist also ein Pflichtbewusster. Na dazu sag' ich mal nichts."), null)
			elseif (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, false, tr("Das Gold."), null)
				call speech(info, character, true, tr("Gib lieber Acht mein Freund. Viele derer, die ich kannte hat die Gier ins Verderben getrieben. Wäre schade um dich."), null)
			elseif (character.class() == Classes.ranger()) then
				call speech(info, character, false, tr("Die Wildnis."), null)
				call speech(info, character, true, tr("Ja, das kann ich verstehen. Ich liebe auch die Natur. Deshalb bin ich auch hierher gezogen. Da, nimm dir einen Apfel."), null)
				call character.giveItem('I03O')
				call speech(info, character, true, tr("(Lachend) Ich fürchte, wir teilen das gleiche Schicksal."), null)
			elseif (character.class() == Classes.elementalMage()) then
				call speech(info, character, false, tr("Der Wille."), null)
				call speech(info, character, true, tr("Der Wille? Was gibt’s hier schon zu erreichen oder holen? Ich meine, mir gefällt’s hier, aber mit dieser Meinung gehöre ich zu einer kleinen Minderheit."), null)
			elseif (character.class() == Classes.illusionist()) then
				call speech(info, character, false, tr("Die Freiheit."), null)
				call speech(info, character, true, tr("Freiheit! Na ja, ich möchte deine Träume nicht zerstören, aber wirklich frei ist in dieser Zeit keiner. Selbst ich muss meinem Herzog dienen und ihm regelmäßig etwas von meinem Hab und Gut abgeben. (Lachend) Ist natürlich freiwillig."), null)
			elseif (character.class() == Classes.wizard()) then
				call speech(info, character, false, tr("Die Neugier."), null)
				call speech(info, character, true, tr("Ich bin vermutlich zu alt, um neugierig zu sein. Aber vielleicht bringt sie dich ja eines Tages weiter als mich. Trotzdem, ich will mich nicht beklagen. Mir geht’s doch eigentlich recht gut."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoConditionYourFerryBoat takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// ￼Ist das deine Fähre?
		private static method infoActionYourFerryBoat takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("￼Ist das deine Fähre?"), null)
			call speech(info, character, true, tr("￼Klar. Die hab ich selbst gebaut und der Holzfäller Kuno hat mir das Holz dafür beschafft. Na ja, er muss ja auch jeden Tag über den Fluss fahren."), null)
			call speech(info, character, true, tr("Natürlich fahre ich auch andere Leute über den Fluss."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Ist das deine Fähre?“, Charakter hat noch nicht mit Kuno gesprochen)
		private static method infoConditionWhoIsKuno takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character) and true /// @todo Hat noch nicht mit Kuno gesprochen
		endmethod

		// Wer ist Kuno?
		private static method infoActionWhoIsKuno takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer ist Kuno?"), null)
			call speech(info, character, true, tr("Ach das ist ein Holzfäller und alter Freund von mir. Ich fahre ihn jeden Tag mit meiner Fähre zweimal über den Fluss. Hin und zurück."), null)
			call speech(info, character, true, tr("Er hat seine Hütte am anderen Flussufer und transportiert sein Holz mit Hilfe meiner Fähre auf meine Seite, um es dann bei den Bauern zu verkaufen."), null)
			call speech(info, character, true, tr("Du kannst ja mal mit ihm sprechen, wenn ich dich hinüber gebracht habe."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoConditionStableHut takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Deine Hütte sieht aber nicht grade stabil aus.
		private static method infoActionStableHut takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine Hütte sieht aber nicht grade stabil aus."), null)
			call speech(info, character, true, tr("Ja, ich weiß. Sie ist wohl im Laufe der Zeit etwas kaputt gegangen. Na ja, ich hab mir auch nicht gerade viel Mühe bei ihrem Bau gegeben."), null)
			call speech(info, character, true, tr("Da fällt mir ein, hättest du nicht vielleicht Lust meinen alten Freund Kuno um etwas Holz zu bitten, das er mir nächstes Mal, wenn er über den Fluss fährt, mitbringt."), null)
			call speech(info, character, false, tr("Wieso machst du das nicht selbst?"), null)
			call speech(info, character, true, tr("Gut, er ist zwar ein alter Freund von mir, aber was seinen Beruf angeht, da hab ich mich wohl ab und zu etwas zu sehr drüber lustig gemacht. War ja nicht böse gemeint, aber er war natürlich wieder total verärgert und jetzt hab ich wirklich keine Lust ihn darum zu bitten."), null)
			call speech(info, character, true, tr("Du würdest natürlich auch was dafür kriegen."), null)
			call info.talk().showRange(11, 13, character)
		endmethod

		// (Nach „Deine Hütte sieht aber nicht grade stabil aus.“, Auftrag „Holz für die Hütte“ wurde noch nicht erhalten)
		private static method infoConditionGetWood takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(5, character) and QuestWoodForTheHut.characterQuest(character).isNotUsed()
		endmethod

		// Ich hab's mir überlegt. Ich besorg dir dein Holz.
		private static method infoActionGetWood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich hab's mir überlegt. Ich besorg dir dein Holz. "), null)
			if (thistype(info.talk()).wasOffended(character.player())) then
				call speech(info, character, true, tr("So so, ein wenig Gier steckt also doch in jedem von uns. Na ja, mir soll's recht sein."), null)
			else
				call speech(info, character, true, tr("Danke Mann. Du tust mir damit einen wirklich großen Gefallen."), null)
			endif
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“, Trommon befindet sich in seinem Gemüsegarten)
		private static method infoConditionNiceGarden takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_trommons_vegetable_garden, gg_unit_n021_0004)
		endmethod

		// Einen hübschen Gemüsegarten hast du da.
		private static method infoActionNiceGarden takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Einen hübschen Gemüsegarten hast du da."), null)
			call speech(info, character, true, tr("Findest du wirklich? Das freut mich aber. Vielleicht möchtest du ja etwas von meinem Gemüse kaufen. Zur Zeit kann ich wieder mehr ernten als ich für mich selbst brauche."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Holz für die Hütte“ ist abgeschlossen, Auftragsziel 2 des Auftrags „Holz für die Hütte“ ist aktiv, Charakter hat Bretter dabei)
		private static method infoConditionGetSomeWood takes AInfo info, ACharacter character returns boolean
			return QuestWoodForTheHut.characterQuest(character).questItem(0).isCompleted() and  QuestWoodForTheHut.characterQuest(character).questItem(1).isNew() and character.inventory().hasItemType('I03P')
		endmethod

// 		// Hier sind ein paar Bretter von Kuno.
		private static method infoActionGetSomeWood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier sind ein paar Bretter von Kuno."), null)
			call speech(info, character, true, tr("Wirklich? Ich danke dir. Hier hast du ein paar Salatköpfe aus meinem Gemüsegarten und natürlich auch ein paar Goldmünzen."), null)
			// Bretter entfernt
			call character.inventory().removeItemType('I03P')
			// Auftrag „Holz für die Hütte“ abgeschlossen
			call QuestWoodForTheHut.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Holz für die Hütte“ ist abgeschlossen)
		private static method infoConditionMoreHelp takes AInfo info, ACharacter character returns boolean
			return QuestWoodForTheHut.characterQuest(character).isCompleted()
		endmethod
		
		// Brauchst du sonst noch etwas?
		private static method infoActionMoreHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Brauchst du sonst noch etwas?"), null)
			call speech(info, character, true, tr("Wenn du schon fragst, dann sage ich einfach mal „ja“. Wegen meiner Fähre kann ich hier schlecht weg. Die Arbeit auf der Fähre finde ich jedoch recht eintönig."), null)
			call speech(info, character, true, tr("Viel lieber würde ich mich jetzt weiter um meinen kleinen Garten kümmern. Leider kenne ich mich noch nicht so gut aus mit allem, was man so anpflanzen kann."), null)
			call speech(info, character, true, tr("Südlich vom Bauernhof lebt eine alte Frau namens Ursula. Sie kennt sich mit solchen Dingen besser aus, denke ich."), null)
			call speech(info, character, true, tr("Pass auf, ich gebe dir 50 Goldmünzen und du schaust, was du dafür von ihr bekommen kannst. Ich denke sie ist sehr ehrlich und hoffe du bist es auch."), null)
			// 50 Goldmünzen erhalten.
			call character.addGold(50)
			// Neuer Auftrag „Samen für den Garten“
			call QuestSeedsForTheGarden.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Samen für den Garten“ ist abgeschlossen, Auftragsziel 2 des Auftrags „Samen für den Garten“ ist aktiv, Charakter hat Samen dabei)
		private static method infoConditionSpecialSeed takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(0).isCompleted() and QuestSeedsForTheGarden.characterQuest(character).questItem(1).isNew() and  character.inventory().hasItemType('I03N')
		endmethod
		
		// Hier hast du einen ganz besonderen Samen.
		private static method infoActionSpecialSeed takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du einen ganz besonderen Samen."), null)
			call speech(info, character, true, tr("Zeig her! Was ist daran so besonders?"), null)
			call speech(info, character, false, tr("Das siehst, du wenn es soweit ist."), null)
			call speech(info, character, true, tr("Hm, ich vertraue dir mal. Hab vielen Dank und nimm das hier als Belohnung."), null)
			call speech(info, character, true, tr("Wenn du willst kannst du ihn selbst einpflanzen."), null)
			// Auftragsziel 2 des Auftrags „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).questItem(1).setState(AAbstractQuest.stateCompleted)
			// Auftragsziel 3 des Auftrags „Samen für den Garten“ aktiviert
			call QuestSeedsForTheGarden.characterQuest(character).questItem(2).setState(AAbstractQuest.stateNew)
			// Auftragsziel 4 des Auftrags „Samen für den Garten“ aktiviert
			call QuestSeedsForTheGarden.characterQuest(character).questItem(3).setState(AAbstractQuest.stateNew)
			call QuestSeedsForTheGarden.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 3 des Auftrags „Samen für den Garten“ abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionWhatDoYouThink takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(2).isCompleted() and QuestSeedsForTheGarden.characterQuest(character).questItem(3).isNew()
		endmethod
		
		// Und was hältst du von dem Baum?
		private static method infoActionWhatDoYouThink takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Und was hältst du von dem Baum?"), null)
			call speech(info, character, true, tr("Unglaublich und er scheint eine magische Wirkung auf seine Umgebung zu haben."), null)
			call speech(info, character, true, tr("Damit hätte ich nicht gerechnet. Hier nimm das, ich hoffe das reicht dir als Entschädigung für deine Mühen."), null)
			// Auftrag „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Kein Problem, mache ich.
		private static method infoActionStableHut_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kein Problem, mache ich."), null)
			call speech(info, character, true, tr("Danke Mann. Du tust mir damit einen wirklich großen Gefallen."), null)
			call QuestWoodForTheHut.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.
		private static method infoActionStableHut_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig."), null)
			call speech(info, character, true, tr("Verdammt Mann, krieg dich wieder ein! War ja nicht böse gemeint, dann halt nicht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Ich überleg's mir mal.
		private static method infoActionStableHut_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich überleg's mir mal."), null)
			call speech(info, character, true, tr("In Ordnnug."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n021_0004, thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_hasPaid[i] = false
				set this.m_wasOffended[i] = false
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoConditionYourFerryBoat, thistype.infoActionYourFerryBoat, tr("￼Ist das deine Fähre?")) // 1
			call this.addInfo(false, false, thistype.infoConditionWhoIsKuno, thistype.infoActionWhoIsKuno, tr("Wer ist Kuno?")) // 2
			call this.addInfo(false, false, thistype.infoConditionStableHut, thistype.infoActionStableHut, tr("Deine Hütte sieht aber nicht grade stabil aus.")) // 3
			call this.addInfo(false, false, thistype.infoConditionGetWood, thistype.infoActionGetWood, tr("Ich hab's mir überlegt. Ich besorg dir dein Holz.")) // 4
			call this.addInfo(false, false, thistype.infoConditionNiceGarden, thistype.infoActionNiceGarden, tr("Einen hübschen Gemüsegarten hast du da.")) // 5
			call this.addInfo(false, false, thistype.infoConditionGetSomeWood, thistype.infoActionGetSomeWood, tr("Hier sind ein paar Bretter von Kuno.")) // 6
			call this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tr("Brauchst du sonst noch etwas?")) // 7
			call this.addInfo(false, false, thistype.infoConditionSpecialSeed, thistype.infoActionSpecialSeed, tr("Hier hast du einen ganz besonderen Samen.")) // 8
			call this.addInfo(false, false, thistype.infoConditionWhatDoYouThink, thistype.infoActionWhatDoYouThink, tr("Und was hältst du von dem Baum?")) // 9
			call this.addExitButton() // 10

			// page 5
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_0, tr("Kein Problem, mache ich.")) // 11
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_1, tr("Du kannst mich mal! Meines Vaters Vater, also mein Großvater und wiederum dessen Vater, also mein Urgroßvater, die waren alle Holzfäller und du machst dich einfach darüber lustig.")) // 12
			call this.addInfo(false, false, 0, thistype.infoActionStableHut_2, tr("Ich überleg's mir mal.")) // 13

			return this
		endmethod
	endstruct

endlibrary