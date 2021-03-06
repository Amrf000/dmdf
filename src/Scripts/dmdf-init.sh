#!/bin/bash
# This scripts initialzes all required file paths which are used by the other ones.

function echoSuccess()
{
	echo -en '\E[32m'
	echo -en '\E[1m'
	echo "$1"
	tput sgr0
}

function echoError()
{
	echo -en '\E[31m'
	echo -en '\E[1m'
	echo "$1" >&2
	tput sgr0
}

function echoStats()
{
	echo -en '\E[34m'
	echo -en '\E[1m'
	echo "$1"
	tput sgr0
}

echoSuccess "Die Macht des Feuers"
export WC3_PATH=~/Dokumente/Spiele/Warcraft\ III
echoStats "Warcraft III is located at \"$WC3_PATH\"."
export OPT_PATH=~/Dokumente/Projekte/wc3tools/Warcraft3MapOptimizier
echoStats "Warcraft III Optimizer is located at \"$OPT_PATH\"."
export JNGP_PATH=~/Dokumente/Projekte/wc3tools/jassnewgenpack5d
echoStats "JNGP is located at \"$JNGP_PATH\"."
#export JASSHELPER_PATH=~/Dokumente/Projekte/wc3tools/0.A.2.B.jasshelper/executable
export JASSHELPER_PATH=$JNGP_PATH/jasshelper
echoStats "JassHelper is located at \"$JASSHELPER_PATH\"."
export ASL_PATH=~/Dokumente/Projekte/asl
echoStats "Advanced Script Library is located at \"$ASL_PATH\"."
export DMDF_PATH=~/Dokumente/Projekte/DMdF
echoStats "Die Macht des Feuers is located at \"$DMDF_PATH\"."
export EXTERNAL_MOUNT_PATH=./extern
echoStats "External mount path is \"$EXTERNAL_MOUNT_PATH\"."
export EXTERNAL_PATH=$EXTERNAL_MOUNT_PATH/HTUADC/cdauth-old/disk2\ \(E\)
echoStats "External data is located at \"$EXTERNAL_PATH\"."
export ASL_EXTERNAL_PATH=$EXTERNAL_PATH/Projekte/ASL
echoStats "External Advanced Script Libray is located at \"$ASL_EXTERNAL_PATH\"."
export DMDF_EXTERNAL_PATH=$EXTERNAL_PATH/Projekte/DMdF
echoStats "External Die Macht des Feuers is located at \"$DMDF_EXTERNAL_PATH\"."
export ASL_SMB_PATH=~/Desktop/smb/Projekte/ASL
echoStats "SMB Advanced Script Library is located at \"$ASL_SMB_PATH\"."
export DMDF_SMB_PATH=~/Desktop/smb/Projekte/Die\ Macht\ des\ Feuers
echoStats "SMB Die Macht des Feuers is located at \"$DMDF_SMB_PATH\"."
export MAP_PATH_TALRAS="$DMDF_PATH/maps/Karte 1 - Talras.w3x"
echoStats "Map \"Talras\" is located at \"$MAP_PATH_TALRAS\"."
export MAP_PATH_HOLZBRUCK="$DMDF_PATH/maps/Karte 2 - Holzbruck.w3x"
echoStats "Map \"Holzbruck\" is located at \"$MAP_PATH_HOLZBRUCK\"."

function ask()
{
	echo "$1"
	echo -n "(y/n):"

	while [ 1 ] ; do
		read value
		case "$value" in
			"y" | "Y" | "yes" | "YES")
				return 1
				;;
			"n" | "N" | "no" | "NO")
				echoStats "Canceled."
				return 0
				;;
		esac
	done

	return 0
}

function checkPath()
{
	if [ -e "$1" ]; then
		echoSuccess "Path \"$1\" exists."

		return 0
	fi

	echoError "Path \"$1\" does not exist."

	return 1
}

function checkExternalPaths()
{
	checkPath "$ASL_EXTERNAL_PATH"
	checkPath "$DMDF_EXTERNAL_PATH"
}

function checkPaths()
{
	checkPath "$JNGP_PATH"
	checkPath "$JASSHELPER_PATH"
	checkPath "$ASL_PATH"
	checkPath "$DMDF_PATH"
	checkPath "$EXTERNAL_MOUNT_PATH"
	checkPath "$ASL_EXTERNAL_PATH"
	checkPath "$DMDF_EXTERNAL_PATH"
	checkPath "$ASL_SMB_PATH"
	checkPath "$DMDF_SMB_PATH"
	checkPath "$MAP_PATH_TALRAS"
	checkPath "$MAP_PATH_HOLZBRUCK"
}

function mountExternal()
{
	if ! [ -d "$EXTERNAL_MOUNT_PATH" ] ; then
		echoStats "Since mounting directory \"$EXTERNAL_MOUNT_PATH\" does not exist it's being created now."
		mkdir "$EXTERNAL_MOUNT_PATH"
	fi

	if ! (cat /proc/mounts | grep -q "$EXTERNAL_MOUNT_PATH") ; then
		if fusesmb "$EXTERNAL_MOUNT_PATH" ; then
			echoSuccess "Mounted \"$EXTERNAL_MOUNT_PATH\" successfully."
			echoStats $(df -h | grep "$EXTERNAL_MOUNT_PATH")
			checkExternalPaths

			return 0
		else
			echoError "Error while mounting \"$EXTERNAL_MOUNT_PATH\"."

			return 1
		fi
	fi

	echoSuccess "Already mounted \"$EXTERNAL_MOUNT_PATH\"."
	checkExternalPaths

	return 0
}

# arg 1: ASL external path
# arg 2: Die Macht des Feuers external path
function updateExternalArchives()
{
	if mountExternal ; then
		RSYNC_OPTIONS="-aPhum --delete"

		# updating archive data
		if [ -e "$1" ]; then
			echoSuccess "Updating files in \"$1\"."
			rsync $RSYNC_OPTIONS "$ASL_PATH/archives" "$1"
		else
			echoError "Error while updating files in \"$1\"."

			return 1
		fi

		if [ -e "$2" ]; then
			echoSuccess "Updating files in \"$2\"."
			rsync $RSYNC_OPTIONS "$DMDF_PATH/archives" "$2"
		else
			echoError "Error while updating files in \"$2\"."

			return 1
		fi

		return 0
	fi

	echoError "Error while updating files in \"$1\" and \"$2\"."

	return 1
}

function updateExternalSrc()
{
	if mountExternal ; then
		if ! [ -d "$ASL_EXTERNAL_PATH/src" ] ; then
			echoError "Source code directory \"$ASL_EXTERNAL_PATH/src\" does not exist."
			return 1
		fi

		if ! [ -d "$DMDF_EXTERNAL_PATH/src" ] ; then
			echoError "Source code directory \"$DMDF_EXTERNAL_PATH/src\" does not exist."
			return 1
		fi

		RSYNC_OPTIONS="-aPhum --delete"
		echoSuccess "Updating files in \"$ASL_EXTERNAL_PATH/src\"."
		rsync $RSYNC_OPTIONS "$ASL_PATH/src/" "$ASL_EXTERNAL_PATH/src"
		echoSuccess "Updating files in \"$DMDF_EXTERNAL_PATH/src\"."
		rsync $RSYNC_OPTIONS "$DMDF_PATH/src/" "$DMDF_EXTERNAL_PATH/src"

		return 0
	fi

	return 1
}

function checkMpqArchive()
{
	if [ -e "$1" ]; then
		if [ -r "$1" ]; then
			if [ ! -w "$1" ]; then
				echoError "Warning: Archive \"$1\" is not writable."
			fi
			# TODO add warnings
			return 0
		else
			echoError "Warning: Archive \"$1\" is not readable."
		fi
	else
		echoError "Warning: Archive \"$1\" does not exist."
	fi

	return 1
}

function showMpqInfo()
{
	if checkMpqArchive "$1" ; then
		mpq-info "$1"
		return 0
	fi

	return 1
}

function listMpqFiles()
{
	if [ ! -z "$2" ]; then
		mpq-extract -l "$1" | grep "$2"
	else
		mpq-extract -l "$1"
	fi
}

function extractMpqFiles()
{
	if checkMpqArchive "$1"; then
		if [ -ewd "$2" ]; then
			mpq-extract -e "$1" "$2"
			return 0
		fi
		echoError "Access error on directory \"$2\" (is not a directory or wrong permissions?)."
	fi

	return 1
}

#function buildMpqArchive()
#{
	#source=$1
	#destination=$2
	# TODO Cut name and create archive, mpq-tools do not provide MPQ archive creation

	#svn export -f $source $destination
#}

function compileMap()
{
	if [ ! -e "$1" ]; then
		echoError "Map file \"$1\" does not exist."
		return 1
	elif [ ! -r "$1" ]; then
		echoError "Map file \"$1\" is not readable." >&2
		return 1
	elif [ ! -w "$1" ]; then
		echoError "Map file \"$1\" is not writable." >&2
		return 1
	fi

	cd "$JASSHELPER_PATH"
	# setup additional parameters
	jasshelperParameters="--debug"

	echoError "Compiling map \"$1\"."

	if wine "$JASSHELPER_PATH/jasshelper.exe" $jasshelperParameters "$ASL_PATH/src/common.j" "$ASL_PATH/src/Blizzard.j" "$1"; then
		if wine "$JASSHELPER_PATH/JassParserCLI.exe" $ASL_PATH/src/common.j $ASL_PATH/src/Blizzard.j logs/outputwar3map.j; then
			return 0
		fi
	fi

	echoError "Error during compilation of map \"$1\"."

	return 1
}

function compileMapTalras()
{
	compileMap "$MAP_PATH_TALRAS"

	return $?
}

function compileMapHolzbruck()
{
	compileMap "$MAP_PATH_HOLZBRUCK"

	return $?
}

function compileAllMaps()
{
	if compileMapTalras; then
		if compileMapHolzbruck; then
			return 0
		fi
	fi

	return 1
}

function startWorldEditor()
{
	wine "$JNGP_PATH"/NewGen\ WE.exe -opengl

	return $?
}

function startGame()
{
	#wine "$JNGP_PATH"/NewGen\ Warcraft.exe -opengl
	wine "$WC3_PATH/Frozen Throne.exe" $@

	return $?
}
