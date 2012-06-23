//! import "Talras/Videos/Struct Video A New Alliance.j"
//! import "Talras/Videos/Struct Video Bloodthirstiness.j"
//! import "Talras/Videos/Struct Video Death Vault.j"
//! import "Talras/Videos/Struct Video Dragon Hunt.j"
//! import "Talras/Videos/Struct Video Intro.j"
//! import "Talras/Videos/Struct Video Rescue Dago 0.j"
//! import "Talras/Videos/Struct Video Rescue Dago 1.j"
//! import "Talras/Videos/Struct Video The Castle.j"
//! import "Talras/Videos/Struct Video The Chief.j"
//! import "Talras/Videos/Struct Video The Duke Of Talras.j"
//! import "Talras/Videos/Struct Video The First Combat.j"
//! import "Talras/Videos/Struct Video Upstream.j"
//! import "Talras/Videos/Struct Video Wigberht.j"

library MapVideos requires StructMapVideosVideoANewAlliance, StructMapVideosVideoBloodthirstiness, StructMapVideosVideoDeathVault, StructMapVideosVideoDragonHunt, StructMapVideosVideoIntro, StructMapVideosVideoRescueDago0, StructMapVideosVideoRescueDago1, StructMapVideosVideoTheCastle, StructMapVideosVideoTheChief, StructMapVideosVideoTheDukeOfTalras, StructMapVideosVideoTheFirstCombat, StructMapVideosVideoUpstream, StructMapVideosVideoWigberht

	function initMapVideos takes nothing returns nothing
		call VideoANewAlliance.initVideo()
		call VideoBloodthirstiness.initVideo()
		call VideoDeathVault.initVideo()
		call VideoDragonHunt.initVideo()
		call VideoIntro.initVideo()
		call VideoRescueDago0.initVideo()
		call VideoRescueDago1.initVideo()
		call VideoTheCastle.initVideo()
		call VideoTheChief.initVideo()
		call VideoTheDukeOfTalras.initVideo()
		call VideoTheFirstCombat.initVideo()
		call VideoUpstream.initVideo()
		call VideoWigberht.initVideo()
	endfunction

endlibrary