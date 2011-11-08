/// Cleric
library StructSpellsSpellExorcizeEvil requires Asl, StructGameClasses, StructGameSpell

	/// Der Kleriker verursacht bei einem Gegner X Punkte Schaden und verringert für 10 Sekunden dessen Bewegungsgeschwindigkeit auf Y% und Angriffsgeschwindigkeit auf Z%. 1 Minute Abklingzeit.
	struct SpellExorcizeEvil extends Spell
		public static constant integer abilityId = 'A08L'
		public static constant integer favouriteAbilityId = 'A08M'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary