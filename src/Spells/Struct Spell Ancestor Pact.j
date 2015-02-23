/// Necromancer
library StructSpellsSpellAncestorPact requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Der Nekromant regeneriert sein Leben und Mana mit Hilfe eines Kadavers. Wandelt X% des ursprünglichen Lebens des Ziels zu Leben und Y% zu Mana um.
	 */
	struct SpellAncestorPact extends Spell
		public static constant integer abilityId = 'A08N'
		public static constant integer favouriteAbilityId = 'A08I'
		public static constant integer maxLevel = 5
		private static constant real targetRadius = 200.0
		private static constant real lifePercentage = 0.10
		private static constant real lifePercentageLevelValue = 10.0 // ab Stufe 1
		private static constant real manaPercentage = 0.0
		private static constant real manaPercentageLevelValue = 10.0 // ab Stufe 1
		private AGroup unitGroup
		private unit target

		private static method unitFilter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit())
		endmethod
		
		public stub method onCastCondition takes nothing returns boolean
			set this.target = null
			call this.unitGroup.units().clear()
			call this.unitGroup.addUnitsInRangeCounted(GetSpellTargetX(), GetSpellTargetY(), thistype.targetRadius, Filter(function thistype.unitFilter), 1)
			if (this.unitGroup.units().empty()) then
				call this.unitGroup.destroy()
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
				return false
			endif
			
			set this.target = this.unitGroup.units()[0]
			call this.unitGroup.units().clear()
			
			if (GetUnitState(this.character().unit(), UNIT_STATE_LIFE) < GetUnitState(this.character().unit(), UNIT_STATE_MAX_LIFE)) then
				return true
			elseif (GetUnitState(this.character().unit(), UNIT_STATE_MANA) < GetUnitState(this.character().unit(), UNIT_STATE_MAX_MANA)) then
				if (GetUnitState(this.target, UNIT_STATE_MAX_MANA) > 0.0) then
					return true
				else
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel hat kein Mana."))
				endif
			else
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Charakter hat volle Werte."))
			endif
			
			return false
		endmethod

		public stub method onCastAction takes nothing returns nothing
			local real life
			local real mana
			set life =  GetUnitState(this.target, UNIT_STATE_MAX_LIFE) * (thistype.lifePercentage + (this.level() - 1) * thistype.lifePercentageLevelValue)
			set life = RMinBJ(life, GetUnitMissingLife(this.character().unit()))
			set mana = GetUnitState(this.target, UNIT_STATE_MAX_MANA) * (thistype.manaPercentage + (this.level() - 1) * thistype.manaPercentageLevelValue)
			set mana = RMinBJ(mana, GetUnitMissingMana(this.character().unit()))
			
			if (life > 0.0) then
				call SetUnitLifeBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_LIFE) + life)
				call thistype.showLifeTextTag(this.character().unit(), life)
			endif
			
			if (mana > 0.0) then
				call SetUnitManaBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_MANA) + mana)
				call thistype.showManaTextTag(this.character().unit(), mana)
			endif
			
			call unitGroup.destroy()
			call RemoveUnit(this.target)
			set this.target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.unitGroup = AGroup.create()
			
			call this.addGrimoireEntry('A0RK', 'A0RP')
			call this.addGrimoireEntry('A0RL', 'A0RQ')
			call this.addGrimoireEntry('A0RM', 'A0RR')
			call this.addGrimoireEntry('A0RM', 'A0RS')
			call this.addGrimoireEntry('A0RO', 'A0RT')
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call this.unitGroup.destroy()
		endmethod
	endstruct

endlibrary