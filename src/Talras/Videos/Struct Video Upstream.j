library StructMapVideosVideoUpstream requires Asl, StructGameGame

	struct VideoUpstream extends AVideo
		private integer m_actorBoat
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorNarrator
		private integer m_actorNorseman0
		private integer m_actorNorseman1
		private integer m_actorKuno
		private integer m_actorKunosDaughter
		private integer m_actorGiant
		private AGroup m_group
	
		implement Video

		private static method playMusic takes nothing returns nothing
			call PlayThematicMusic("Music\\Upstream.mp3")
			call TriggerSleepAction(228.0) /// @todo Replace by WaitForMusic or something else (more exact).
			loop
				call PlayThematicMusic("Music\\Credits.mp3")
				call TriggerSleepAction(415.0) /// @todo Replace by WaitForMusic or something else (more exact).
			endloop
		endmethod
		
		private static method dialogButtonActionYes takes ADialogButton dialogButton returns nothing
			if (dialogButton.dialog().player() == GetLocalPlayer()) then
				call EndGame(true)
			endif
		endmethod
		
		private static method dialogButtonActionNo takes ADialogButton dialogButton returns nothing
			local force whichForce = CreateForce()
			call ForceAddPlayer(whichForce, dialogButton.dialog().player())
			call CinematicModeBJ(true, whichForce)
			call DestroyForce(whichForce)
			set whichForce = null
		endmethod
		
		public stub method onSkipCondition takes player skippingPlayer, integer skipablePlayers returns boolean
			local force whichForce = CreateForce()
			call ForceAddPlayer(whichForce, skippingPlayer)
			call CinematicModeBJ(false, whichForce)
			call DestroyForce(whichForce)
			set whichForce = null
			call AGui.playerGui(skippingPlayer).dialog().clear()
			call AGui.playerGui(skippingPlayer).dialog().setMessage(tr("Spiel verlassen?"))
			call AGui.playerGui(skippingPlayer).dialog().addDialogButtonIndex(tr("Ja"), thistype.dialogButtonActionYes)
			call AGui.playerGui(skippingPlayer).dialog().addDialogButtonIndex(tr("Nein"), thistype.dialogButtonActionNo)
			call AGui.playerGui(skippingPlayer).dialog().show()
		
			return false
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(19.0)
			
			// hide old norseman
			call ShowUnit(gg_unit_n01I_0150, false)
			call ShowUnit(gg_unit_n01I_0151, false)
			call ShowUnit(gg_unit_n01I_0152, false)
			call ShowUnit(gg_unit_n01I_0153, false)
			
			set this.m_actorBoat = thistype.saveUnitActor(gg_unit_n02E_0103)
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_upstream_actor)
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorWigberht = thistype.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_upstream_wigberht)
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorWigberht), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorRicman = thistype.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_upstream_ricman)
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorRicman), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorDragonSlayer = thistype.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorDragonSlayer), gg_rct_video_upstream_dragon_slayer)
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorNarrator = thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n00W', gg_rct_video_upstream_narrator, GetRandomFacing())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorNarrator), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorNorseman0 = thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_video_upstream_norseman_0, GetRandomFacing())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorNorseman0), thistype.unitActor(this.m_actorBoat))
			set this.m_actorNorseman1 = thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_video_upstream_norseman_1, GetRandomFacing())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorNorseman1), thistype.unitActor(this.m_actorBoat))
			
			set this.m_actorKuno = thistype.saveUnitActor(Npcs.kuno())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorKuno), gg_rct_video_upstream_kuno)
			call SetUnitFacing(thistype.unitActor(this.m_actorKuno), 106.44)
			
			set this.m_actorKunosDaughter = thistype.saveUnitActor(Npcs.kunosDaughter())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorKunosDaughter), gg_rct_video_upstream_kunos_daughter)
			call SetUnitFacing(thistype.unitActor(this.m_actorKunosDaughter), 106.44)
			
			set this.m_actorGiant = thistype.createUnitActorAtRect(MapData.alliedPlayer, UnitTypes.giant, gg_rct_video_upstream_giant_start, 272.22)
			call SetUnitColor(thistype.unitActor(this.m_actorGiant), GetPlayerColor(Player(PLAYER_NEUTRAL_PASSIVE)))
			
			set this.m_group = AGroup.create()
			call this.m_group.units().pushBack(thistype.actor())
			call this.m_group.units().pushBack(thistype.unitActor(this.m_actorWigberht))
			call this.m_group.units().pushBack(thistype.unitActor(this.m_actorRicman))
			call this.m_group.units().pushBack(thistype.unitActor(this.m_actorDragonSlayer))
			call this.m_group.units().pushBack(thistype.unitActor(this.m_actorNorseman0))
			call this.m_group.units().pushBack(thistype.unitActor(this.m_actorNorseman1))
			
			call thistype.playMusic.execute()
			call CameraSetupApplyForceDuration(gg_cam_upstream_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_upstream_1, true, 8.0)
		endmethod

		private method continueShipRoute takes nothing returns nothing
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_2,  thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_3)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_3, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_4)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_4, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_5)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_5, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_6)
		endmethod

		private static method showMovingTextTag takes string text, real size, integer red, integer green, integer blue, integer alpha returns nothing
			local texttag textTag = CreateTextTag()
			call SetTextTagText(textTag, text, 0.023)
			call SetTextTagPos(textTag, CameraSetupGetDestPositionX(gg_cam_upstream_6), CameraSetupGetDestPositionY(gg_cam_upstream_6), CameraSetupGetField(gg_cam_upstream_6, CAMERA_FIELD_ZOFFSET) + 16.0)
			call SetTextTagColor(textTag, red, green, blue, alpha)
			call SetTextTagVisibility(textTag, true)
			call SetTextTagVelocity(textTag, 0.0, 0.020)
			set textTag = null
		endmethod
		
		private static method slowDown takes unit whichUnit returns nothing
			call SetUnitMoveSpeed(whichUnit, 100.0)
		endmethod
		
		private static method hide takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local integer i

			if (wait(5.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_upstream_2, true, 6.0)
			
			if (wait(5.0)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorNarrator), tr("So segelten sie gemeinsam mit den Nordmännern nach Holzbruck. Doch was dort geschah ist eine andere Geschichte ..."), gg_snd_ErzaehlerFlussaufwaerts1)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerFlussaufwaerts1))) then
				return
			endif
			
			call this.m_group.forGroup(thistype.slowDown)
			call this.m_group.pointOrder("move", GetRectCenterX(gg_rct_video_upstream_enter_boat), GetRectCenterY(gg_rct_video_upstream_enter_boat))
			

			call CameraSetupApplyForceDuration(gg_cam_upstream_3, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_upstream_4, true, 0.0)
			
			call this.m_group.forGroup(thistype.hide)
			
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_0)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_0, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_5, true, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_1)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_1, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_6, true, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_2)

			call this.continueShipRoute.execute()

			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Wenn Sie das Video überspringen, können Sie das Spiel verlassen."))
			
			if (wait(3.0)) then
				return
			endif

			call thistype.showMovingTextTag("Die Macht des Feuers", 16.0, 255, 0, 0, 0)

			if (wait(3.0)) then
				return
			endif

			set i = 0
			loop
				exitwhen (i == Credits.contributors.evaluate())

				if (not Credits.contributorIsTitle.evaluate(i)) then
					call thistype.showMovingTextTag(Credits.contributorDescription.evaluate(i), 14.0, 255, 255, 255, 0)
					
					if (wait(2.00)) then
						return
					endif
				endif
	
				
				if (not Credits.contributorIsTitle.evaluate(i)) then
					call thistype.showMovingTextTag(Credits.contributorName.evaluate(i), 14.0, 255, 255, 255, 0)
				else
					call thistype.showMovingTextTag(Credits.contributorName.evaluate(i), 16.0, 255, 0, 0, 0)
				endif
				
				if (wait(5.0)) then
					return
				endif

				set i = i + 1
			endloop

			call thistype.showMovingTextTag(tr("Vielen Dank fürs Spielen."), 16.0, 255, 255, 255, 0)

			if (wait(4.0)) then
				return
			endif
			
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Überspringen Sie das Video, um das Spiel zu verlassen."))
			
			call IssueRectOrder(thistype.unitActor(this.m_actorGiant), "move", gg_rct_video_upstream_giant_target)
			
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_giant_target, thistype.unitActor(this.m_actorGiant)))

				if (wait(1.0)) then
					return
				endif
			endloop
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorGiant), thistype.unitActor(this.m_actorBoat))
			
			call SetUnitAnimation(thistype.unitActor(this.m_actorGiant), "Attack Slam")
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorGiant), tr("Haaalt! Wartet doch! Ich will auch mit, nehmt mich mit! Diese Karte ist langweilig!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorKuno), thistype.unitActor(this.m_actorGiant))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorKunosDaughter), thistype.unitActor(this.m_actorGiant))
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorKuno), tr("Was soll denn das? Verschwinde! Ich sehe überhaupt nichts!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorKunosDaughter), tr("Ja, wir sehen gar nichts! Du stehst in unserem Sichtfeld."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorGiant), thistype.unitActor(this.m_actorKuno))
			
			if (wait(1.0)) then
				return
			endif
			
			call SetUnitAnimation(thistype.unitActor(this.m_actorGiant), "Stand")
			call SetUnitAnimationByIndex(thistype.unitActor(this.m_actorGiant), 3)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorGiant), tr("Oh, ich bitte um Verzeihung."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call IssueRectOrder(thistype.unitActor(this.m_actorGiant), "move", gg_rct_video_upstream_giant_start)
			
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_giant_start, thistype.unitActor(this.m_actorGiant)))

				if (wait(1.0)) then
					return
				endif
			endloop
			
			call EndGame(true)
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call this.m_group.destroy()
			call EndGame(true)
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary