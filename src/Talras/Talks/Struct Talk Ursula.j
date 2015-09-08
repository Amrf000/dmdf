library StructMapTalksTalkUrsula requires Asl, StructMapQuestsQuestTheOaksPower, StructMapQuestsQuestSeedsForTheGarden

	struct TalkUrsula extends Talk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(10, character)
		endmethod

		// Was machst du hier?
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du hier?"), null)
			call speech(info, character, true, tr("Leben. Dies ist mein Heim, Fremder. Vielleicht etwas ungewohnt für einen aus unserem Königreich Stammenden, aber hier lässt es sich durchaus leben."), gg_snd_Ursula1)
			call speech(info, character, true, tr("Ich bin Ursula, Waldläuferin, Druidin und Heilerin. Das heißt, ich bin keine Jägerin, denn ich respektiere das Leben, sei es nun das eines Menschen, Hochelfen, Tieres oder eines anderen Lebewesens. Druidin bedeutet, dass ich an die Göttin Krepar, die Göttin der Natur, glaube."), gg_snd_Ursula2)
			call speech(info, character, true, tr("Ich weiß, viele Leute haben sich von den Göttern abgewandt, selbst im Adel ist es mehr zu einer Art Zeitvertreib und Symbolik für Wohlstand und Rechtschaffenheit geworden. Aber ich glaube aus meinem tiefsten Inneren heraus."), gg_snd_Ursula3)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wie ist dein Leben hier draußen so?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie ist dein Leben hier draußen so?"), null)
			call speech(info, character, true, tr("Angenehm und auch nicht einsam, falls du das glaubst. Oft kommen die Bauern und auch manche Jäger zu mir und suchen Heilung oder meinen Rat."), gg_snd_Ursula4)
			call speech(info, character, true, tr("Nur hier draußen fühle ich mich zu Natur verbunden genug, um Krepar eine würdige Dienerin oder besser gesagt Freundin zu sein."), gg_snd_Ursula5)
			call speech(info, character, true, tr("Manchmal mache ich auch lange Wanderungen durch die hiesigen Wälder, um die Schönheit zu betrachten, die Krepar uns schenkte."), gg_snd_Ursula6)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Womit verdienst du deinen Lebensunterhalt?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Womit verdienst du deinen Lebensunterhalt?"), null)
			call speech(info, character, true, tr("Ich brauche nicht viel zum Leben. Das Meiste erhalte ich durch Gnade Krepars von der Natur und den Rest verdiene ich mir sowohl durch meinen Rat und Beistand als auch durch meine Heilkünste und mein altes Wissen."), gg_snd_Ursula7)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Erzähl mir mehr von Krepar.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir mehr von Krepar."), null)
			call speech(info, character, true, tr("Krepar ist eine der vier Götter. Einst war ich eine Dienerin der Kleriker, welche den Gott Urkarus verehren. Bei diesen lernte ich durch meine Stellung als Bibliothekarin der großen Bibliothek des Ordens in Klerfurt eine Menge über die alte Gesellschaft, die sich noch stärker zur Natur verbunden fühlte."), gg_snd_Ursula8)
			call speech(info, character, true, tr("Damals lebten die Leute noch in einfachen Hütten in den Wäldern und waren eins mit der Natur."), gg_snd_Ursula9)
			call speech(info, character, true, tr("Druiden, weise Persönlichkeiten, beteten Krepar, die Göttin der Natur und Symbiose an. Auf ihren Rat hörten die Bewohner der kleinen Siedlungen und suchten ihren Rat, wenn es etwas zu bewältigen gab."), gg_snd_Ursula10)
			call speech(info, character, true, tr("Anders als die heutigen Orden, gab es weniger durch die Herkunft bedingte Herrschaftshierarchien. Man respektierte die Alten und Weisen, denn ihr Rat war meist der beste."), gg_snd_Ursula11)
			call speech(info, character, true, tr("Krepar schuf die Natur um uns herum. Jeder Baum, jede Pflanze und jedes Tier ist ein Geschöpf ihrer. Daher sollte man sie ehren und dankbar sein."), gg_snd_Ursula12)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kannst du mich heilen?
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kannst du mich heilen?"), null)
			call speech(info, character, true, tr("Krepar, leihe mir deine Kraft!"), gg_snd_Ursula13)
			call QueueUnitAnimation(gg_unit_n01U_0203, "Spell")
			call DestroyEffect(AddSpecialEffectTarget("Spells\\Models\\Effects\\Genesung.mdl", character.unit(), "chest"))
			call SetUnitLifePercentBJ(gg_unit_n01U_0203, 100.0)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Sehe ich denn aus als bräuchte ich Hilfe?"), gg_snd_Ursula14)
			call speech(info, character, false, tr("Na ja …"), null)
			call speech(info, character, true, tr("Schon gut, ich brauche tatsächlich Hilfe."), gg_snd_Ursula15)
			call speech(info, character, true, tr("Ganz in der Nähe gibt es eine alte Eiche. Sie spendete mir stets Schatten während meiner langen Stunden des Philosophierens über dieses einfache Leben, das Krepar mir geschenkt hat. Doch nun haben starke, wilde Kreaturen die Eiche für sich in Anspruch genommen."), gg_snd_Ursula16)
			call speech(info, character, true, tr("Da aber auch sie Geschöpfe Krepars sind, möchte ich, dass du sie nicht tötest, sondern ihre Geister einfängst."), gg_snd_Ursula17)
			call speech(info, character, false, tr("Wie soll ich das anstellen?"), null)
			call speech(info, character, true, tr("Dazu gebe ich dir diesen Totem. Bringe mir den Geist von einer der Kreaturen, damit ich sie verstehen lerne und mich mit ihnen anfreunden kann und ich werde dir etwas schenken."), gg_snd_Ursula18)
			call speech(info, character, false, tr("Und was?"), null)
			call speech(info, character, true, tr("Das siehst du dann noch."), gg_snd_Ursula19)
			call info.talk().showRange(11, 12, character)
		endmethod

		// (Nachdem der Charakter gefragt hat, ob er irgendwie helfen kann)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(5, character)
		endmethod

		// Du kannst die Geister wilder Kreaturen einfangen?
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du kannst die Geister wilder Kreaturen einfangen?"), null)
			call speech(info, character, true, tr("Ja, jeder kann das. Man braucht nur Geduld und muss von der Vorstellung der Vorherrschaft seiner eigenen Art wegkommen. Zeige dem Lebewesen deinen Respekt. Wenn du das beherrscht, wird es auch dich respektieren und das ermöglicht dir, zu seinem Geist durchzudringen."), gg_snd_Ursula22)
			call speech(info, character, true, tr("Natürlich lernt man das nicht mal eben so, vielleicht ist „einfangen“ auch das falsche Wort. Man versucht vielmehr eins zu werden mit der Kreatur und wenn sie deine gute Absicht bemerkt, lässt sie dich an ihren Geist heran."), gg_snd_Ursula23)
			call speech(info, character, false, tr("Aber was ist daran eine gute Absicht?"), null)
			call speech(info, character, true, tr("Nun, ich lasse den Geist ja wieder frei, nachdem wir Informationen miteinander ausgetauscht haben."), gg_snd_Ursula24)
			call speech(info, character, false, tr("Informationen?"), null)
			call speech(info, character, true, tr("Du würdest dich sicher wundern, wenn du wüsstest, wie viel eine wilde Kreatur weiß. Sie vermag es vielleicht nicht, es aufzuschreiben oder anderen durch Sprache mitzuteilen, aber viele der wilden Kreaturen, auf die ich traf wussten mehr als so mancher sogenannter Zivilisierter."), gg_snd_Ursula25)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Die Kraft der Eiche“ ist aktiv)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return QuestTheOaksPower.characterQuest(character).questItem(1).isNew()
		endmethod

		// Hier hast du deinen Totem wieder.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du deinen Totem wieder."), null)
			// Charakter gibt Ursula den Totem zurück.
			call character.inventory().removeItemType(QuestTheOaksPower.itemTypeId)
			call speech(info, character, true, tr("Du hast es also geschafft? Gut gemacht. Pass auf, ich gebe dir einen anderen Totem mit einem Teil der Kraft dieser Kreatur."), gg_snd_Ursula26)
			call speech(info, character, true, tr("Mit dem Toten wirst du in der Lage sein, die Kreatur herbeizurufen, zumindest mit einem Teil ihrer ursprünglichen Stärke. Allerdings wird sie nicht ihrem eigenen Instinkt folgen, sondern dir stattdessen stets treu ergeben sein."), gg_snd_Ursula27)
			call speech(info, character, true, tr("Ziehe einen guten Nutzen daraus und behandle sie gut. Hier hast du noch ein paar Goldmünzen für deine Hilfe. Nun kann ich endlich eins werden mit diesen Wesen und mein Wissen mit ihnen teilen und auch von ihnen lernen."), gg_snd_Ursula28)
			// Auftrag „Die Kraft der Eiche“ abgeschlossen.
			call QuestTheOaksPower.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Verkaufst du auch was?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Verkaufst du auch was?"), null)
			call speech(info, character, true, tr("Ja, ich möchte mein Wissen teilen. Einige meiner Bücher nützen mir nicht mehr viel, denn ich kenne sie bereits fast auswendig. Diese verkaufe ich, damit ich mir noch etwas Lebensunterhalt dazu verdienen kann."), gg_snd_Ursula29)
			call speech(info, character, true, tr("Ich werde nämlich langsam zu alt, um hinauszuziehen und Nahrung zu sammeln."), gg_snd_Ursula30)
			call speech(info, character, true, tr("Auch wenn ich nicht viel von Besitz halte, so verkaufe ich die Bücher nicht gerade billig, da es wohl mein einziger, für gewöhnliche Leute ebenfalls wertvoller Besitz ist. Und glaube mir, es sind wahre Schätze darunter!"), gg_snd_Ursula31)
			call speech(info, character, true, tr("Noch viel wertvoller aber sind die Kreaturen, die mir von Zeit zu Zeit zulaufen. Sie sind zwar nicht mein Besitz, aber ich verlange auch für sie ein paar Goldmünzen, da sie mir auf Dauer sehr ans Herz wachsen."), gg_snd_Ursula32)
			call speech(info, character, false, tr("Wovon sprichst du?"), null)
			call speech(info, character, true, tr("Von den Katzen, die mir zulaufen. Hier in der Gegend scheint es von Katzen nur so zu wimmeln. Ich teile mein Essen mit ihnen und sie leben mit mir zusammen."), gg_snd_Ursula33)
			call speech(info, character, true, tr("Da es wohl immer mehr werden, werde ich mich vermutlich von einigen von ihnen trennen  müssen, wenn ich nicht selbst verhungern will."), gg_snd_Ursula34)
			call speech(info, character, true, tr("Wenn du mir versprichst dich gut um sie zu kümmern, werde ich dir auch sie verkaufen."), gg_snd_Ursula35)
			call speech(info, character, true, tr("Außerdem habe ich noch einige Gegenstände, um einen wahren Druiden auszurüsten. Vielleicht interessiert du dich ja dafür."), gg_snd_Ursula36)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Samen für den Garten“ ist aktiv, permanent)
		private static method infoConditionSeedForTheGarden takes AInfo info, ACharacter character returns boolean
			return QuestSeedsForTheGarden.characterQuest(character).questItem(0).isNew()
		endmethod
		
		// Trommon benötigt ein paar Samen für seinen Garten.
		private static method infoActionSeedForTheGarden takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Trommon benötigt ein paar Samen für seinen Garten."), null)
			call speech(info, character, true, tr("Trommon der Fährmann?"), gg_snd_Ursula37)
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Tatsächlich, er will sich also als Gärtner versuchen? Nun, wenn er so viel Vertrauen in mich setzt, muss ich ihn wohl dafür belohnen."), gg_snd_Ursula38)
			call speech(info, character, true, tr("Hat er dir denn etwas mitgegeben um mich zu bezahlen?"), gg_snd_Ursula39)
			call info.talk().showRange(13, 14, character)
		endmethod

		// Gut.
		private static method infoAction5_0 takes AInfo info, ACharacter character returns nothing
			local item whichItem
			call speech(info, character, false, tr("Gut."), null)
			call speech(info, character, true, tr("Ich danke dir."), gg_snd_Ursula20)
			// Neuer Auftrag „Die Kraft der Eiche“
			call QuestTheOaksPower.characterQuest(character).enable()
			set whichItem = CreateItem(QuestTheOaksPower.itemTypeId, GetUnitX(character.unit()), GetUnitY(character.unit()))
			call SetItemInvulnerable(whichItem, true)
			call SetItemPawnable(whichItem, false)
			call UnitAddItem(character.unit(), whichItem)
			call info.talk().showStartPage(character)
		endmethod

		// Kein Interesse.
		private static method infoAction5_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kein Interesse."), null)
			call speech(info, character, true, tr("Wie du meinst."), gg_snd_Ursula21)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Charakter hat mindestens 50 Goldmünzen, permanent)
		private static method infoConditionEnoughGold takes AInfo info, ACharacter character returns boolean
			return character.gold() >= 50
		endmethod
		
		// Ja.
		private static method infoActionSeedForTheGarden_Yes takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Gut, gib mir die Goldmünzen und du erhältst einen sehr wertvollen, magischen Samen."), gg_snd_Ursula40)
			call speech(info, character, true, tr("Aber was daraus entstehen wird bleibt ein Geheimnis."), gg_snd_Ursula41)
			// Goldmünzen entfernen
			call character.removeGold(50)
			// „Magischer Samen“ erhalten
			call character.giveQuestItem('I03N')
			// Auftragsziel 1 des Auftrags „Samen für den Garten“ abgeschlossen
			call QuestSeedsForTheGarden.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// Nein.
		private static method infoActionSeedForTheGarden_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Tut mir Leid aber ganz umsonst werde ich das nicht entbehren."), gg_snd_Ursula42)
			call info.talk().showStartPage(character)
		endmethod
		
		// TODO
		// gg_snd_Ursula43

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01U_0203, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Was machst du hier?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Wie ist dein Leben hier draußen so?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Womit verdienst du deinen Lebensunterhalt?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Erzähl mir mehr von Krepar.")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Kannst du mich heilen?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Kann ich dir irgendwie helfen?")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Du kannst die Geister wilder Kreaturen einfangen?")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Hier hast du deinen Totem wieder.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Verkaufst du auch was?")) // 8
			call this.addInfo(true, false, thistype.infoConditionSeedForTheGarden, thistype.infoActionSeedForTheGarden, tr("Trommon benötigt ein paar Samen für seinen Garten.")) // 9
			call this.addExitButton() // 10

			// info 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tr("Gut.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tr("Kein Interesse.")) // 12
			
			// info 9
			call this.addInfo(true, false, thistype.infoConditionEnoughGold, thistype.infoActionSeedForTheGarden_Yes, tr("Ja.")) // 13
			call this.addInfo(true, false, 0, thistype.infoActionSeedForTheGarden_No, tr("Nein.")) // 14

			return this
		endmethod
	endstruct

endlibrary