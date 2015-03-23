/// Cleric
library StructSpellsSpellGodsFavor requires Asl, StructGameClasses, StructGameSpell

	/// Erhöht die Rüstung eines Verbündeten um X.
	struct SpellGodsFavor extends Spell
		public static constant integer abilityId = 'A0QB'
		public static constant integer favouriteAbilityId = 'A0QC'
		public static constant integer maxLevel = 5
		

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A0QD', 'A0QI')
			call this.addGrimoireEntry('A0QE', 'A0QJ')
			call this.addGrimoireEntry('A0QF', 'A0QK')
			call this.addGrimoireEntry('A0QG', 'A0QL')
			call this.addGrimoireEntry('A0QH', 'A0QM')
			
			return this
		endmethod
	endstruct

endlibrary