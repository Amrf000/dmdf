/// Dragon Slayer
library StructSpellsSpellBeastHunter requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Grundfähigkeit: Bestienjäger - Passiv. Schaden gegen wilde Kreaturen wird um 10% erhöht.
	struct SpellBeastHunter extends Spell
		public static constant integer abilityId = 'A0T2'
		public static constant integer favouriteAbilityId = 'A076'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary