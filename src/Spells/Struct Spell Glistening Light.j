/// Elemental Mage
library StructSpellsSpellGlisteningLight requires Asl, StructGameClasses, StructGameSpell

	struct SpellGlisteningLight extends Spell
		public static constant integer abilityId = 'A01B'
		public static constant integer favouriteAbilityId = 'A03M'
		public static constant integer maxLevel = 5
		private static constant real timeSummand = 2.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local effect spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "origin")
			local real time = this.level() + thistype.timeSummand
			call PauseUnit(target, true)
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call PauseUnit(target, false)
			call DestroyEffect(spellEffect)
			set spellEffect = null
			set caster = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary