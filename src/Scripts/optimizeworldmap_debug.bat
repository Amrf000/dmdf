set OUTPUT_FILEPATH="C:\Users\tamino\Documents\Warcraft III\Maps\DMDF\WorldMap1.0.w3x"
del %OUTPUT_FILEPATH%
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\WorldMap.w3x" --do %OUTPUT_FILEPATH% --checkscriptstuff --exit