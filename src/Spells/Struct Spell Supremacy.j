/// Dragon Slayer
library StructSpellsSpellSupremacy requires Asl, StructGameClasses, StructGameSpell

	/// Der Drachentöter erhöht sein Angriffstempo X Sekunden lang um 150%. 40 Sekunden Abklingzeit.
	struct SpellSupremacy extends Spell
		public static constant integer abilityId = 'A06W'
		public static constant integer favouriteAbilityId = 'A06X'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary