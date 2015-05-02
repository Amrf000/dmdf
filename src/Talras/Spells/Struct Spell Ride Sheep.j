/// Item
library StructMapSpellsSpellRideSheep requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellRideSheep extends SpellMetamorphosis
	
		public stub method onMorph takes nothing returns nothing
			/**
			 * This tag adds the sheep.
			 * Actually it is already set for the unit but somehow is removed on passive hero transformation.
			 */
			//call AddUnitAnimationProperties(this.character().unit(), "Upgrade", true)
			//debug call Print("After adding animation property to unit " + GetUnitName(this.character().unit()))
		endmethod
		
		public stub method onRestore takes nothing returns nothing
			/**
			 * This tag adds the sheep.
			 * Actually it is already set for the unit but somehow is removed on passive hero transformation.
			 */
			//call AddUnitAnimationProperties(this.character().unit(), "Upgrade", false)
			//debug call Print("After removing animation property from unit " + GetUnitName(this.character().unit()))
		endmethod

		public static method create takes Character character, integer abilityId, integer morphAbiliyId, integer unmorphAbilityId returns thistype
			local thistype this = thistype.allocate(character, abilityId, morphAbiliyId, unmorphAbilityId)
			call this.setDisableGrimoire(false)
			call this.setDisableInventory(false)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary