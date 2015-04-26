/// Druid
library StructSpellsSpellWrathOfTheForest requires Asl, StructGameClasses, StructGameSpell

	struct SpellWrathOfTheForest extends Spell
		public static constant integer abilityId = 'A09X'
		public static constant integer favouriteAbilityId = 'A09Y'
		public static constant integer classSelectionAbilityId = 'A0ED'
		public static constant integer classSelectionGrimoireAbilityId = 'A0EI'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0ED', 'A0EI')
			call this.addGrimoireEntry('A0EE', 'A0EJ')
			call this.addGrimoireEntry('A0EF', 'A0EK')
			call this.addGrimoireEntry('A0EG', 'A0EL')
			call this.addGrimoireEntry('A0EH', 'A0EM')
			
			return this
		endmethod
	endstruct

endlibrary