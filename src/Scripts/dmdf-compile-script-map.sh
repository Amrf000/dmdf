#!/bin/bash
source dmdf-init

SCRIPT_PATH=$DMDF_PATH/src/Talras/war3map.j
MAP_PATH=$DMDF_PATH/maps/Karte\ 1\ -\ Talras.w3x
echo "Compiling script is located at \"$SCRIPT_PATH\"."
echo "Compiling map is located at \"$MAP_PATH\"."
cd "$JASSHELPER_PATH"
# --debug
wine "$JASSHELPER_PATH/clijasshelper.exe" --debug "$ASL_PATH/src/common.j" "$ASL_PATH/src/Blizzard.j" "$SCRIPT_PATH" "$MAP_PATH"
