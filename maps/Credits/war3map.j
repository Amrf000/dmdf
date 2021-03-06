//===========================================================================
// 
// Mitwirkende
// 
//   Warcraft III map script
//   Generated by the Warcraft III World Editor
//   Date: Mon Oct 30 08:47:58 2017
//   Map Author: Baradé
// 
//===========================================================================

//***************************************************************************
//*
//*  Global Variables
//*
//***************************************************************************

globals
    // User-defined
    integer                 udg_MaximumGroupIndex      = 0
    integer                 udg_Index                  = 0
    integer array           udg_UnitType
    integer                 udg_CurrentIndex           = 0

    // Generated
    rect                    gg_rct_class_selection     = null
    rect                    gg_rct_credits_end         = null
    rect                    gg_rct_credits_start       = null
    rect                    gg_rct_main_window_credits = null
    rect                    gg_rct_main_window_info_log = null
    camerasetup             gg_cam_class_selection     = null
    camerasetup             gg_cam_credits             = null
    camerasetup             gg_cam_main_window         = null
    trigger                 gg_trg_Init_Settings       = null
    trigger                 gg_trg_Start               = null
    trigger                 gg_trg_Unit_Types          = null
    trigger                 gg_trg_Remove_On_Enter     = null
endglobals

function InitGlobals takes nothing returns nothing
    local integer i = 0
    set udg_MaximumGroupIndex = 0
    set udg_Index = 0
    set udg_CurrentIndex = 0
endfunction

//***************************************************************************
//*
//*  Unit Creation
//*
//***************************************************************************

//===========================================================================
function CreateNeutralPassive takes nothing returns nothing
    local player p = Player(PLAYER_NEUTRAL_PASSIVE)
    local unit u
    local integer unitID
    local trigger t
    local real life

    set u = CreateUnit( p, 'Hblm', -2832.9, 827.3, 171.330 )
endfunction

//===========================================================================
function CreatePlayerBuildings takes nothing returns nothing
endfunction

//===========================================================================
function CreatePlayerUnits takes nothing returns nothing
endfunction

//===========================================================================
function CreateAllUnits takes nothing returns nothing
    call CreatePlayerBuildings(  )
    call CreateNeutralPassive(  )
    call CreatePlayerUnits(  )
endfunction

//***************************************************************************
//*
//*  Regions
//*
//***************************************************************************

function CreateRegions takes nothing returns nothing
    local weathereffect we

    set gg_rct_class_selection = Rect( -416.0, 0.0, -384.0, 32.0 )
    set gg_rct_credits_end = Rect( -2144.0, -576.0, -1728.0, -160.0 )
    set gg_rct_credits_start = Rect( 1024.0, -384.0, 1056.0, -352.0 )
    set gg_rct_main_window_credits = Rect( -1984.0, -1632.0, 1152.0, 960.0 )
    set gg_rct_main_window_info_log = Rect( -2112.0, 992.0, 1216.0, 3072.0 )
endfunction

//***************************************************************************
//*
//*  Cameras
//*
//***************************************************************************

function CreateCameras takes nothing returns nothing

    set gg_cam_class_selection = CreateCameraSetup(  )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_ZOFFSET, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_ROTATION, 90.0, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_ANGLE_OF_ATTACK, 335.6, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_TARGET_DISTANCE, 2657.3, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_ROLL, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0 )
    call CameraSetupSetField( gg_cam_class_selection, CAMERA_FIELD_FARZ, 7320.5, 0.0 )
    call CameraSetupSetDestPosition( gg_cam_class_selection, -400.5, -77.8, 0.0 )

    set gg_cam_credits = CreateCameraSetup(  )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_ZOFFSET, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_ROTATION, 90.0, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_ANGLE_OF_ATTACK, 335.6, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_TARGET_DISTANCE, 2196.1, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_ROLL, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0 )
    call CameraSetupSetField( gg_cam_credits, CAMERA_FIELD_FARZ, 7320.5, 0.0 )
    call CameraSetupSetDestPosition( gg_cam_credits, -400.5, -77.8, 0.0 )

    set gg_cam_main_window = CreateCameraSetup(  )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_ZOFFSET, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_ROTATION, 90.0, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_ANGLE_OF_ATTACK, 335.6, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_TARGET_DISTANCE, 2657.3, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_ROLL, 0.0, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0 )
    call CameraSetupSetField( gg_cam_main_window, CAMERA_FIELD_FARZ, 7320.5, 0.0 )
    call CameraSetupSetDestPosition( gg_cam_main_window, -400.5, -77.8, 0.0 )

endfunction

//***************************************************************************
//*
//*  Custom Script Code
//*
//***************************************************************************
//TESH.scrollpos=0
//TESH.alwaysfold=0
//! import "TriggerData/TPof.j"
//***************************************************************************
//*
//*  Triggers
//*
//***************************************************************************

//===========================================================================
// Trigger: Init Settings
//===========================================================================
function Trig_Init_Settings_Actions takes nothing returns nothing
    call SetMapSettingsMapName( "CT" )
    call SetMapSettingsAlliedPlayer( Player(6) )
    call SetMapSettingsStartLevel( 1 )
    // Unit Types
    set udg_UnitType[udg_Index] = 'hrif'
    set udg_Index = ( udg_Index + 1 )
    set udg_MaximumGroupIndex = udg_Index
endfunction

//===========================================================================
function InitTrig_Init_Settings takes nothing returns nothing
    set gg_trg_Init_Settings = CreateTrigger(  )
    call TriggerRegisterMapInitSettingsEvent( gg_trg_Init_Settings )
    call TriggerAddAction( gg_trg_Init_Settings, function Trig_Init_Settings_Actions )
endfunction

//===========================================================================
// Trigger: Start
//===========================================================================
function Trig_Start_Actions takes nothing returns nothing
    call EnableTrigger( gg_trg_Unit_Types )
    call TriggerExecute( gg_trg_Unit_Types )
endfunction

//===========================================================================
function InitTrig_Start takes nothing returns nothing
    set gg_trg_Start = CreateTrigger(  )
    call TriggerRegisterMapStartEvent( gg_trg_Start )
    call TriggerAddAction( gg_trg_Start, function Trig_Start_Actions )
endfunction

//===========================================================================
// Trigger: Unit Types
//===========================================================================
function Trig_Unit_Types_Func003C takes nothing returns boolean
    if ( not ( ( udg_CurrentIndex + 1 ) >= udg_MaximumGroupIndex ) ) then
        return false
    endif
    return true
endfunction

function Trig_Unit_Types_Actions takes nothing returns nothing
    call CreateNUnitsAtLoc( 1, udg_UnitType[udg_CurrentIndex], Player(PLAYER_NEUTRAL_PASSIVE), GetRectCenter(gg_rct_credits_start), 180.00 )
    call GroupPointOrderLocBJ( GetLastCreatedGroup(), "move", GetRectCenter(gg_rct_credits_end) )
    if ( Trig_Unit_Types_Func003C() ) then
        set udg_CurrentIndex = 0
    else
        set udg_CurrentIndex = ( udg_CurrentIndex + 1 )
    endif
endfunction

//===========================================================================
function InitTrig_Unit_Types takes nothing returns nothing
    set gg_trg_Unit_Types = CreateTrigger(  )
    call DisableTrigger( gg_trg_Unit_Types )
    call TriggerRegisterTimerEventPeriodic( gg_trg_Unit_Types, 10.00 )
    call TriggerAddAction( gg_trg_Unit_Types, function Trig_Unit_Types_Actions )
endfunction

//===========================================================================
// Trigger: Remove On Enter
//===========================================================================
function Trig_Remove_On_Enter_Conditions takes nothing returns boolean
    if ( not ( GetOwningPlayer(GetTriggerUnit()) == Player(PLAYER_NEUTRAL_PASSIVE) ) ) then
        return false
    endif
    return true
endfunction

function Trig_Remove_On_Enter_Actions takes nothing returns nothing
    call RemoveUnit( GetTriggerUnit() )
endfunction

//===========================================================================
function InitTrig_Remove_On_Enter takes nothing returns nothing
    set gg_trg_Remove_On_Enter = CreateTrigger(  )
    call TriggerRegisterEnterRectSimple( gg_trg_Remove_On_Enter, gg_rct_credits_end )
    call TriggerAddCondition( gg_trg_Remove_On_Enter, Condition( function Trig_Remove_On_Enter_Conditions ) )
    call TriggerAddAction( gg_trg_Remove_On_Enter, function Trig_Remove_On_Enter_Actions )
endfunction

//===========================================================================
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Init_Settings(  )
    call InitTrig_Start(  )
    call InitTrig_Unit_Types(  )
    call InitTrig_Remove_On_Enter(  )
endfunction

//***************************************************************************
//*
//*  Players
//*
//***************************************************************************

function InitCustomPlayerSlots takes nothing returns nothing

    // Player 0
    call SetPlayerStartLocation( Player(0), 0 )
    call ForcePlayerStartLocation( Player(0), 0 )
    call SetPlayerColor( Player(0), ConvertPlayerColor(0) )
    call SetPlayerRacePreference( Player(0), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(0), false )
    call SetPlayerController( Player(0), MAP_CONTROL_USER )

    // Player 1
    call SetPlayerStartLocation( Player(1), 1 )
    call ForcePlayerStartLocation( Player(1), 1 )
    call SetPlayerColor( Player(1), ConvertPlayerColor(1) )
    call SetPlayerRacePreference( Player(1), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(1), false )
    call SetPlayerController( Player(1), MAP_CONTROL_USER )

    // Player 2
    call SetPlayerStartLocation( Player(2), 2 )
    call ForcePlayerStartLocation( Player(2), 2 )
    call SetPlayerColor( Player(2), ConvertPlayerColor(2) )
    call SetPlayerRacePreference( Player(2), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(2), false )
    call SetPlayerController( Player(2), MAP_CONTROL_USER )

    // Player 3
    call SetPlayerStartLocation( Player(3), 3 )
    call ForcePlayerStartLocation( Player(3), 3 )
    call SetPlayerColor( Player(3), ConvertPlayerColor(3) )
    call SetPlayerRacePreference( Player(3), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(3), false )
    call SetPlayerController( Player(3), MAP_CONTROL_USER )

    // Player 4
    call SetPlayerStartLocation( Player(4), 4 )
    call ForcePlayerStartLocation( Player(4), 4 )
    call SetPlayerColor( Player(4), ConvertPlayerColor(4) )
    call SetPlayerRacePreference( Player(4), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(4), false )
    call SetPlayerController( Player(4), MAP_CONTROL_USER )

    // Player 5
    call SetPlayerStartLocation( Player(5), 5 )
    call ForcePlayerStartLocation( Player(5), 5 )
    call SetPlayerColor( Player(5), ConvertPlayerColor(5) )
    call SetPlayerRacePreference( Player(5), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(5), false )
    call SetPlayerController( Player(5), MAP_CONTROL_USER )

    // Player 6
    call SetPlayerStartLocation( Player(6), 6 )
    call SetPlayerColor( Player(6), ConvertPlayerColor(6) )
    call SetPlayerRacePreference( Player(6), RACE_PREF_HUMAN )
    call SetPlayerRaceSelectable( Player(6), false )
    call SetPlayerController( Player(6), MAP_CONTROL_COMPUTER )

endfunction

function InitCustomTeams takes nothing returns nothing
    // Force: TRIGSTR_015
    call SetPlayerTeam( Player(0), 0 )
    call SetPlayerState( Player(0), PLAYER_STATE_ALLIED_VICTORY, 1 )
    call SetPlayerTeam( Player(1), 0 )
    call SetPlayerState( Player(1), PLAYER_STATE_ALLIED_VICTORY, 1 )
    call SetPlayerTeam( Player(2), 0 )
    call SetPlayerState( Player(2), PLAYER_STATE_ALLIED_VICTORY, 1 )
    call SetPlayerTeam( Player(3), 0 )
    call SetPlayerState( Player(3), PLAYER_STATE_ALLIED_VICTORY, 1 )
    call SetPlayerTeam( Player(4), 0 )
    call SetPlayerState( Player(4), PLAYER_STATE_ALLIED_VICTORY, 1 )
    call SetPlayerTeam( Player(5), 0 )
    call SetPlayerState( Player(5), PLAYER_STATE_ALLIED_VICTORY, 1 )

    //   Allied
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateAllyBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateAllyBJ( Player(5), Player(4), true )

    //   Shared Vision
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(0), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(1), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(2), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(4), true )
    call SetPlayerAllianceStateVisionBJ( Player(3), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(4), Player(5), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(0), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(1), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(2), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(3), true )
    call SetPlayerAllianceStateVisionBJ( Player(5), Player(4), true )

    // Force: TRIGSTR_014
    call SetPlayerTeam( Player(6), 1 )
    call SetPlayerState( Player(6), PLAYER_STATE_ALLIED_VICTORY, 1 )

endfunction

function InitAllyPriorities takes nothing returns nothing

    call SetStartLocPrioCount( 0, 5 )
    call SetStartLocPrio( 0, 0, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 3, 4, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 0, 4, 5, MAP_LOC_PRIO_HIGH )

    call SetStartLocPrioCount( 1, 5 )
    call SetStartLocPrio( 1, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 1, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 3, 4, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 1, 4, 5, MAP_LOC_PRIO_HIGH )

    call SetStartLocPrioCount( 2, 5 )
    call SetStartLocPrio( 2, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 2, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 3, 4, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 2, 4, 5, MAP_LOC_PRIO_HIGH )

    call SetStartLocPrioCount( 3, 5 )
    call SetStartLocPrio( 3, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 2, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 3, 4, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 3, 4, 5, MAP_LOC_PRIO_HIGH )

    call SetStartLocPrioCount( 4, 5 )
    call SetStartLocPrio( 4, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 4, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 4, 2, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 4, 3, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 4, 4, 5, MAP_LOC_PRIO_HIGH )

    call SetStartLocPrioCount( 5, 5 )
    call SetStartLocPrio( 5, 0, 0, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 5, 1, 1, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 5, 2, 2, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 5, 3, 3, MAP_LOC_PRIO_HIGH )
    call SetStartLocPrio( 5, 4, 4, MAP_LOC_PRIO_HIGH )
endfunction

//***************************************************************************
//*
//*  Main Initialization
//*
//***************************************************************************

//===========================================================================
function main takes nothing returns nothing
    call SetCameraBounds( -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM) )
    call SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" )
    call NewSoundEnvironment( "Default" )
    call SetAmbientDaySound( "LordaeronSummerDay" )
    call SetAmbientNightSound( "LordaeronSummerNight" )
    call SetMapMusic( "Music", true, 0 )
    call CreateRegions(  )
    call CreateCameras(  )
    call CreateAllUnits(  )
    call InitBlizzard(  )
    call InitGlobals(  )
    call InitCustomTriggers(  )

endfunction

//***************************************************************************
//*
//*  Map Configuration
//*
//***************************************************************************

function config takes nothing returns nothing
    call SetMapName( "TRIGSTR_001" )
    call SetMapDescription( "TRIGSTR_003" )
    call SetPlayers( 7 )
    call SetTeams( 7 )
    call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )

    call DefineStartLocation( 0, -384.0, -576.0 )
    call DefineStartLocation( 1, -384.0, -576.0 )
    call DefineStartLocation( 2, -384.0, -576.0 )
    call DefineStartLocation( 3, -384.0, -576.0 )
    call DefineStartLocation( 4, -384.0, -576.0 )
    call DefineStartLocation( 5, -384.0, -576.0 )
    call DefineStartLocation( 6, -384.0, -576.0 )

    // Player setup
    call InitCustomPlayerSlots(  )
    call InitCustomTeams(  )
    call InitAllyPriorities(  )
endfunction

