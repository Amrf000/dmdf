The Power of Fire
======================

The Power of Fire (German "Die Macht des Feuers") is a cooperative RPG multiplayer modification of the realtime strategy game Warcraft III: The Frozen Throne.
It alters the game to a roleplay game which can either be played in multiplayer or in a singleplayer campaign which allows traveling between multiple maps.
All source code is put under the GPLv3.

# Table of contents
1. [Introduction](#introduction)
2. [Repository and Resources](#repository_and_resources)
3. [JassHelper Setup](#jasshelper_setup)
4. [JassNewGenPack or SharpCraft World Editor Extended Bundle](#jass_new_gen_pack)
5. [Advanced Script Library](#asl)
    1. [Code Integration](#asl_code_integration)
    2. [Bonus Mod Support](#asl_bonus_mod_support)
6. [vJass](#vjass)
7. [MPQ](#mpq)
8. [Core Systems](#core_systems)
    1. [Fellows](#core_systems_fellows)
    2. [Custom Item Types](#core_systems_custom_item_types)
    3. [Dungeons](#core_systems_dungeons)
    4. [Spawn Points](#core_systems_spawn_points)
    5. [Tree Transparency](#core_systems_tree_transparency)
    6. [Zones](#core_systems_zones)
9. [Creating a new Map](#creating_a_new_map)
    1. [Directory Structure](#creating_a_new_map_directory_structure)
    2. [Importing Code](#creating_a_new_map_importing_code)
    3. [Map Data](#creating_a_new_map_map_data)
    4. [GUI Triggers](#creating_a_new_map_gui_triggers)
    5. [Required Rects](#creating_a_new_map_required_rects)
    6. [Required Camera Setups](#creating_a_new_map_required_camera_setups)
10. [Translation](#translation)
11. [Generating Level Icons for the Grimoire](#generating_level_icons_for_the_grimoire)
12. [Release Process](#release_process)
13. [Trigger Editor Integration](#trigger_editor_integration)
14. [Credits](#credits)

## Repository and Resources <a name="repository_and_resources"></a>
If cloning the repository takes too long, you can make a shallow clone or reduce the clone depth and not clone the whole history.
Since I have pushed the history of binary map and campaign files as well, the history became quite big.

The model, texture and sound resources are not part of this repository.
Download the installation setup from the [ModDB](http://www.moddb.com/mods/warcraft-iii-the-power-of-fire/downloads) to install all resources files.

## JassHelper Setup <a name="jasshelper_setup"></a>
JassHelper 0.A.2.A is required since there is an unknown bug in higher version (0.A.2.B) which prevents
code from being compiled correctly.
Read the following posts for further information:
http://www.wc3c.net/showpost.php?p=1132707&postcount=3630
http://www.wc3c.net/showpost.php?p=1132728&postcount=3632

Options [forcemethodevaluate] and [noimplicitthis] are supported!

Edit "jasshelper.conf" in your Warcraft III directory which comes from the JassNewGenPack and set:
```
[lookupfolders]
// Just type the folders where //! import would look for if relative paths where used, include the final \
// embed them in quotes
// example: "c:\"
// The order causes priority:
"C:\\YourDirectory\\dmdf\\src"

[externaltools]
// this is for //! external NAME args the syntax is "NAME","executable path"
// example:
//"OBJMERGE","c:\kool.exe"

//*
//* grimextension pack by pitzermike:
//*
"FileImporter","grimext\FileImporter.exe"
"ObjectMerger","grimext\ObjectMerger.exe"
"PathMapper","grimext\PathMapper.exe"
"TileSetter","gimext\TileSetter.exe"
"ConstantMerger","grimext\ConstantMerger.exe"
"TriggerMerger","grimext\TriggerMerger.exe"
"FileExporter","grimext\\FileExporter.exe"
"PatchGenerator","grimext\\PatchGenerator.exe"

[wewarlock]
//put the path to WEWarlock between quotes
//Ex: "C:\WeWarlock-0.7.0\WarlockCompiler.exe"

[jasscompiler]
//this is to specify what compiler to use, normally pjass.exe,
// though you may also want to use JassParserCLI.exe ...
"JassParserCLI.exe"
// The next line specifies the jass syntax checker's arguments:
"--report-leaks --pjass $COMMONJ $BLIZZARDJ $WAR3MAPJ"
// i.e. You can change it to "$COMMONJ +rb $BLIZZARDJ -rb $WAR3MAPJ"
// in case of a recent  PJass version ...

[forcemethodevaluate]
[noimplicitthis]
```

Download the [JassParserCLI](http://www.wc3c.net/showthread.php?t=105235).
It has to be installed into the subdirectory "jasshelper" of the Warcraft III directory.
It has to be used instead of pjass since there is a memory exhausted bug in "pjass" (http://www.wc3c.net/showpost.php?p=1115263&postcount=154).

## JassNewGenPack or SharpCraft World Editor Extended Bundle <a name="jass_new_gen_pack"></a>
Use either the [JassNewGenPack](https://www.hiveworkshop.com/threads/jass-newgen-pack-official.290525/) or the [SharpCraft World Editor Extended Bundle](https://www.hiveworkshop.com/threads/sharpcraft-world-editor-extended-bundle.292127) to create and modify maps of the modification.
These tools allow the usage of vJass and disable the Doodad limit of the World Editor.

## Advanced Script Library <a name="asl"></a>
The Advanced Script Library (short ASL) is the core of this modification.
Its code can be found in the ddirectory `src/ASL`.
It has formerly been a separate repository but is now merged into this repository.

### Code Integration <a name="asl_code_integration"></a>
Use file `src/ASL/Import Asl.j` to import all required scripts.
Usually you have to change the lookup folder entry in the "jasshelper.conf" file of your JassHelper
program before.
The JassHelper has to lookup folder "src" in this directory. If configured correctly you're able to
write a simple statement like `//! import "Import Asl.j` into your own code or map script.

The following list shows you which global constants have to be specified in your custom code that ASL works properly:
```
globals
	constant boolean A_SYSTEMS = true
	constant boolean A_DEBUG_HANDLES = false // not usable yet!
	constant boolean A_DEBUG_NATIVES = false
	constant real A_MAX_COLLISION_SIZE = 500.0 // used by function GetUnitCollisionSize
	constant integer A_MAX_COLLISION_SIZE_ITERATIONS = 10 // used by function GetUnitCollisionSize
	constant integer A_SPELL_RESISTANCE_CREEP_LEVEL = 6 // used by function IsUnitSpellResistant
	// used by function GetTimeString()
	constant string A_TEXT_TIME_VALUE = "0%1%"
	constant string A_TEXT_TIME_PAIR = "%1%:%2%"
	// used by ATalk
	constant string A_TEXT_EXIT = "Exit"
	constant string A_TEXT_BACK = "Back"
	constant string A_TEXT_TARGET_TALKS_ALREADY = "Target is already talking."
	// used by ADialog
	constant string A_TEXT_DIALOG_BUTTON = "[%1%] %2%" // first one is the button short cut (integer), second one is the button text (string)
endglobals
```

If you're using debug mode and ASL's debug utilities (ASystemsDebug) you'll have to defined lots of cheat strings.
For default English strings you can import a pre-defined file using:
//! import "Systems/Debug/Text en.j"

WARNING: Apparently, GetLocalizedString() in constant strings crashes the game in map selection!

WARNING: Using % chars in the custom map script leads to unexpected results. You should define the globals somewhere else if possible.

### BonusMod Support <a name="asl_bonus_mod_support"></a>
For using Bonus Mod you have to make an entry in the "jasshelper.conf" file for the object merger tool.
It should always be named "ObjectMerger".
You have to import file "src/ASL/Systems/BonusMod/Creation Bonus Mod.j" once to create all object editor data required by Bonus Mod code.

## vJass <a name="vjass"></a>
[vJass](http://www.wc3c.net/vexorian/jasshelpermanual.html) is a scripting language based on Warcraft III's scripting language JASS. It adds new features like object oriented programming to the scripting language and is implemented by several compilers which translate the vJass code into JASS code.

The first and probably most popular compiler is the [JassHelper](http://www.wc3c.net/showthread.php?t=88142).
It has also been used for The Power of Fire.

By now other approaches with a better syntax exist like Wurst which has not been there when the project was started. It is highly unlikely that the modification will change its core scripting language since too much code is based on it. Besides it has been tested with a specific version of the JassHelper, so there would be a risk of losing functionality or even missing features in the new scripting language.

The size of the modification helped to find the limits of vJass and to make usage of nearly all features. I even wrote many posts on Wc3C.net to improve the language and to report bugs.

## MPQ <a name="mpq"></a>
Warcraft III uses the format MPQ for custom data archives.
Therefore, The Power of Fire provides a custom file called "War3Mod.mpq" with all required resources such as models, textures, icons and sound files.
This file is automatically loaded by Warcraft III when put into its directory.
It is also automatically loaded by the World Editor.

## Core Systems <a name="core_systems"></a>
The code of the modification is based on the Advanced Script Library.
It provides some basic systems which are used in every map of the modification.
The core systems are mostly placed in the folder `src/Game`.

### Fellows <a name="core_systems_fellows"></a>
An NPC fellow is a Warcraft III hero unit which can be shared with one or all players.
This means that the players can control the unit for some time.
The unit is also revived automatically when it dies.
The struct `Fellow` allows the creation of fellows.

### Custom Item Types <a name="core_systems_custom_item_types"></a>
To add range items like bows you have to create a custom item type.

To use the proper attack animations the IDs of the item types have to added to methods like
`ItemTypes.itemTypeIdIsTwoHandedLance()` for example.

### Dungeons <a name="core_systems_dungeons"></a>
Some maps have areas which are use for interiors or dungeons which are separated from the actual playble map.
The struct `Dungeon` allows to specify such ares in form of rects and optionally fixed camera setups.
The player gets the sense of entering a separated area when the character enters a dungeon.

### Spawn Points <a name="core_systems_spawn_points"></a>
The Power of Fire allows you to respawn creeps and items on the map after being killd or picked up.
This should improve the gameplay experience since after clearing a map returning to this map would be less interesting without any new creeps or items to collect.
Besides, the player would get a disadvantage since he cannot level his character nor collect valuable stuff.

Usually the spawn points are created during the map initialization using existing units and items already placed on the map.

### Tree Transparency <a name="core_systems_tree_transparency"></a>
Since the modification uses bigger trees than Warcraft III (for immersion), it is necessary to make them transparent if the player looks at them or the character walks nearby.
The struct `TreeTransparency` handles this automatic transparency management for every player.

### Zones <a name="core_systems_zones"></a>
The modification allows traveling between maps in singleplayer like the Bonus Campaign of Warcraft III: The Frozen Throne.
For every map of the campaign, there has to be a zone.
A complete list of all zones is initialized by the methodd `Zone.initZones()`.
The struct `Zone` can be use to create map exits at certain rects to specified maps.

## Creating a new Map <a name="creating_a_new_map"></a>

To create a new map for the modification, several things have to applied for the map to make it work with the modification.

### Directory Structure <a name="creating_a_new_map_directory_structure"></a>
It's highly recommended by me that you divide your map code into several files which are placed
in various directories.
Your map code folder should look like this:
* `Spells` - directory for map-specific spell structs
* `Map` - directory for default map structs
* `Videos` - directory for map video structs
* `Quests - directory for map quest structs
* `Talks` - directory for map talk structs
* `Import.j` - file for map code library and import statements

### Import Code <a name="creating_a_new_map_importing_code"></a>
Every map has to import the vJass systems of the modification.
Simply add the following code snippet to the custom map script:
```
//! import "Import Dmdf.j"
```
The maps have to be saved with the help of the JassHelper which generates a JASS map script based on the vJass code.

### MapData <a name="creating_a_new_map_map_data"></a>
Every map has to provide a struct called MapData with several methods and static constants which are used by the Game backend of the modification to run all required systems.
```
struct MapData
	private static method create takes nothing returns thistype
		return 0
	endmethod

	private method onDestroy takes nothing returns nothing
	endmethod

	/// Required by \ref Game.
	public static method initSettings takes nothing returns nothing
		call MapSettings.setMapName("AR")
		// Set all MapSettings properties here
	endmethod

	/// Required by \ref Game.
	public static method init takes nothing returns nothing
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 * Required by \ref ClassSelection.
	 */
	public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
	endmethod

	/// Required by \ref Game.
	public static method initMapSpells takes ACharacter character returns nothing
		call initMapCharacterSpells.evaluate(character)
	endmethod

	/// Required by \ref Game.
	public static method onStart takes nothing returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onRepick takes Character character returns nothing
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacter takes string zone, Character character returns nothing
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacters takes string zone returns nothing
	endmethod

	/**
	 * Required by \ref Game. Called by .evaluate()
	 */
	public static method initVideoSettings takes nothing returns nothing
	endmethod

	/**
	 * Required by \ref Game. Called by .evaluate()
	 */
	public static method resetVideoSettings takes nothing returns nothing
	endmethod
endstruct
```

### GUI Triggers <a name="creating_a_new_map_gui_triggers"></a>
Instead of importing the code manually and providing a MapData struct, GUI triggers in the World Editor's trigger editor can be used.
TheNorth.w3x is one existing map which follows this approach rather than using vJass code.
The War3Mod.mpq file has to exist in the Warcraft III directory to use the GUI trigger API provided by The Power of Fire.
When the World Editor is started it show new trigger functions in the trigger editor for the modification.
To use them the following code has to be used in the custom map script:
```
//! import "TriggerData/TPoF.j"
```

There has to be a map settings initialization trigger which looks like this:
```
Init Settings
    Events
        Map - Trigger Register Map Init Settings Event
    Conditions
    Actions
        Map - Set Map Settings Map Name to TN
        Map - Set Map Settings Allied Player to Spieler 7 (GrÃ¼n)
        Map - Set Map Settings Player Neutral feindlich Gives XP True
        Map - Set Map Settings Goldmine to Unit Marktplatz 0008 <gen>
        Map - Set Map Settings Music to Sound\Music\mp3Music\Pippin the Hunchback.mp3;Sound\Music\mp3Music\PippinTheHunchback.mp3
        Map - Set Map Settings Start Level To 60
```

### Required Rects <a name="creating_a_new_map_required_rects"></a>
Every map requires some specific rects for the systems of the modiciation:
* gg_rct_main_window_credits
* gg_rct_main_window_info_log
* gg_rct_class_selection - At the center of this rect the class selection unit is placed.

There is a list of color definitions for those various rect types which are used in maps:
* cheat rects - purple
* quest rects - white
* layer rects - orange
* main window rects - black
* shrine discover rects - yellow
* shrine revival rects - red
* spawn point rects - grey
* video rects - green
* waypoint rects - grey blue
* weather rects - dark green
* music rects - pink
* marker rects - magenta
* default map rects - lite blue

Besides there are some naming conventions:
* cheat rects - "cheat <cheat name>"
* quest rects - "quest <quest name> [quest item <quest item number> | <user-specific description>]"
* layer rects - "layer <layer name> [entry <entry number> | exit <exit number>]"
* main window rects - "main window <main window name>"
* shrine discover rects - "shrine <shrine number|shrine identifier> discover"
* shrine revival rects - "shrine <shrine number|shrine identifier> revival"
* spawn point rects - "spawn point <spawn point identifier|<spawn point creature name> <spawn point number of spawn points with same creature type>>"
* video rects - "video <video name> <rect identifier>"
* waypoint rects - "waypoint <npc name> <rect number|rect identifier>"
* weather rects - "weather <location name>"
* music rects - "music <location name>"
* marker rects - "marker <marker name>"
* default map rects - "<rect name>"

### Required Camera Setups <a name="creating_a_new_map_required_camera_setups"></a>
* gg_cam_class_selection - This camera setup is used for the view of the class selection in the beginning of the game.
* gg_cam_main_window - This camera setup is used for viewing the main windows of the custom GUI system.

## Translation <a name="translation"></a>
To translate all maps as well as the campaign into different languages, one has to extract the war3map.wts files (before optimizing them out). After extracting the files, the entries have to be replaced by strings in another language. A copy of the unoptimized map must be created. Then the modified war3map.wts files have to be readded to the copies of the maps. If the maps are optimized afterwards (both, the one for the original language and the translated), they will differ and on online games won't be considered the same map only translated but the string entries will be optimized and the loading will become faster.

The campaign file has to be copied and uses the translated maps. Besides the information etc. has to be translated.

Besides the file for the user interface has to be replaced.

## Generating Level Icons for the Grimoire <a name="generating_level_icons_for_the_grimoire"></a>
The grimoire icons require an icon with every level from 0 to 6. There is an ability per level for the grimoire since changing the icon of an ability cannot be done dynamically.
The script `Scripts/dmdf-all-grimoire-icons` creates all those icons using ImageMagick.
Since ImageMagick cannot handle BLP files. The icons have to be converted into PNG or TGA files.

## Release Process <a name="release_process"></a>
To update the translations always add English translations to the file "maps/Talras/war3map_en.wts".
To update all translations automatically use wc3trans from the wc3lib project. The script "src/Scripts/jenkins/dmdf_translation.sh" contains everything.

On Windows the project is expected in the directory "E:/Projekte/dmdf".
On Windows the release process consists of the following steps:
* Create the archive TPoF.mpq from the directory "archive".
* Create the executable TPoF.exe with MPQraft using this MPQ archive into the directory "E:/Warcraft III/"
* Export the latest object data from the map "maps/Karte 1 - Talras.w3x" and import it into all other maps (if they use custom Doodads, only import the other parts).
* Save ALL maps with the latest object data and code version. Use `src/Scripts/savemaps.bat` to save the maps automatically. Make sure that the script saves the maps without the "--debug" option for a release. Make sure that no syntax errors are shown anymore and it is saved successfully. Warning: The script uses the exported map scripts of all maps. If they are outdated (files like `maps/Talras/war3map.j`), they have to be extracted from the maps after saving them without the JassHelper enabled.
* Run the script `src/Scripts/makereleasemaps.bat`. This script creates all German release versions of the maps and prepares the English ones.
* Open the prepared English maps (for example in "maps/releases/Arena/Arena<version>.w3x") with an MPQ editor and replace the file war3map.wts in the archive by the file from the same directory.
* After having done this for ALL maps run the script "src/Scripts/makeenglishreleasemaps.bat" which creates the English optimized release maps.
* Open the German campaign "TPoF10de.w3n" and replace all chapters by the maps from "maps/releases" (for example "TL.w3x") and save it.
* Open the English campaign "TPoF10en.w3n" and replace all chapters by the maps from "maps/releases/en" (for example "TL.w3x") and save it.
* Call the NSIS script "src/Scripts/installer.nsi" to create the installer. It includes the development files.

Each map can be optimized using some standard routines. First of all the wc3lib can be used (wc3object) to drop all object data modifications which are not required anymore. This can happen when a hero ability is change to a unit ability but some hero only fields are still changed. This optimization reduces the number of strings which have to be translated or optimized later.

Besides all object data fields which are for the World Editor only can be optimized. These are usually editor only suffixes. The number of modifications (size of the object data) and string entries will be reduced by this which should improve the loading speed of the map.

## Trigger Editor Integration <a name="trigger_editor_integration"></a>
Trigger editor integration means that the trigger editor of the World Editor can be used instead of vJass code.
GUI triggers make it easier for non-programmers to define some logic of the game.
To provide the trigger editor integration, the two files `TriggerData.txt` and `TriggerStrings.txt` have to be generated.
The files `src/TriggerData/TriggerData.txt` and `src/TriggerData/TriggerStrings.txt` are automatically merged by the program wc3converter to generate the files `UI/TriggerData.txt` and `UI/TriggerStrings.txt` in the MPQ archive War3Mod.mpq.

The tool wc3converter is provided by the project [wc3lib](https://github.com/tdauth/wc3lib).
It can be used the following way to create a new trigger data file:
```
wc3converter --merge TriggerDataNew.txt <path to original TriggerData.txt from War3Patch.mpq> gui/UI/TriggerData.txt
```

Then import the file "TriggerDataNew.txt" as `UI\TriggerData.txt`.

Import the file "gui_<language id>/UI/TriggerStrings.txt" as `UI\TriggerStrings.txt`.

Import the file "gui_<language id>/UI/WorldEditStrings.txt" as `UI\WorldEditStrings.txt`.

## Credits <a name="credits"></a>
This modification has been created by Tamino Dauth.
There is many other people which contributed to the modification.
They are listed in the file `src/Game/Credits.j`.
The core team has been:
* Oliver T. - 3D graphics.
* Andreas B. - Much of the terrain of the maps Talras and Holzbruck, testing, design.
* Johanna W. - Testing.

The resources which are not part of this repository like models and textures are mainly from websites like [HIVE](https://www.hiveworkshop.com/) and [Warcraft 3 Campaigns](http://www.wc3c.net/).
They have been created by many different people.