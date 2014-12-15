/// Druid
library StructSpellsSpellBearForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis, StructSpellsSpellAlpha, StructSpellsSpellZoology

	struct SpellBearFormMetamorphosis extends SpellMetamorphosis
		
		public stub method onMorph takes nothing returns nothing
			local integer level
			local integer alphaLevel = 0
			local integer zoologyLevel = 0
			call super.onMorph()
			set level = Character(this.character()).realSpellLevels().integerByInteger(0, SpellBearForm.abilityId)
			debug call Print("Bear Form: Morph! Level: " + I2S(level))
			call SetUnitAbilityLevel(this.character().unit(), SpellBearForm.lifeAbilityId, level)
			call SetUnitAbilityLevel(this.character().unit(), SpellBearForm.damageAbilityId, level)
			
			set alphaLevel =  Character(this.character()).realSpellLevels().integerByInteger(0, SpellAlpha.abilityId)
			debug call Print("Bear Form: Alpha Level: " + I2S(level))
			
			if (alphaLevel > 0) then
				debug call Print("Adding Alpha spell since Alpha is skilled: " + GetAbilityName(SpellAlpha.castAbilityId))
				call UnitAddAbility(this.character().unit(), SpellAlpha.castAbilityId)
			endif
			
			set zoologyLevel =  Character(this.character()).realSpellLevels().integerByInteger(0, SpellZoology.abilityId)
			debug call Print("Bear Form: Zoology Level: " + I2S(zoologyLevel))
			
			if (zoologyLevel > 0) then
				debug call Print("Adding Zoology spell since Zoology is skilled: " + GetAbilityName(SpellZoology.abilityId))
				//call UnitAddAbility(this.character().unit(), SpellZoology.abilityId)
				//call SetUnitAbilityLevel(this.character().unit(), SpellZoology.abilityId, zoologyLevel)
			endif
		endmethod
	endstruct
	
	struct SpellBearForm extends Spell
		public static constant integer abilityId = 'A09H'
		public static constant integer favouriteAbilityId = 'A09S'
		public static constant integer maxLevel = 5
		public static constant integer lifeAbilityId = 'A09Q'
		public static constant integer damageAbilityId = 'A09R'
		private SpellBearFormMetamorphosis m_metamorphosis

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_metamorphosis = SpellBearFormMetamorphosis.create(character, thistype.abilityId)
			call this.m_metamorphosis.setUnitTypeId('H00I')
			call this.addGrimoireEntry('A0C7', 'A0CC')
			call this.addGrimoireEntry('A0C8', 'A0CD')
			call this.addGrimoireEntry('A0C9', 'A0CE')
			call this.addGrimoireEntry('A0CA', 'A0CF')
			call this.addGrimoireEntry('A0CB', 'A0CG')

			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call this.m_metamorphosis.destroy()
			set this.m_metamorphosis = 0
		endmethod
	endstruct

endlibrary