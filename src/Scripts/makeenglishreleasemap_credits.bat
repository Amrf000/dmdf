SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\en\Credits%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\releases\Credits\Credits%VERSION%.w3x" --do "F:\Projekte\dmdf\maps\releases\en\Credits%VERSION%.w3x" --checkscriptstuff --exit
del "F:\Projekte\dmdf\maps\releases\en\CT.w3x"
copy "F:\Projekte\dmdf\maps\releases\en\Credits%VERSION%.w3x" "F:\Projekte\dmdf\maps\releases\en\CT.w3x"