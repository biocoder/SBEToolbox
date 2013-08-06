:: Simple Cytoscape batch script for windows/dos
:: (c) Trey Ideker June 21, 2002; Owen Ozier March 06, 2003
::
:: Runs Cytoscape from its jar file with GO data loaded

@echo off

:: Create the Cytoscape.vmoptions file, if it doesn't exist.
IF EXIST "Cytoscape.vmoptions" GOTO vmoptionsFileExists
CALL gen_vmoptions.bat
:vmoptionsFileExists

IF EXIST "Cytoscape.vmoptions" GOTO itIsThere
; Run with defaults:
echo "*** Missing Cytoscape.vmoptions, falling back to using defaults!"
java -Dswing.aatext=true -Dawt.useSystemAAFontSettings=lcd -Xss10M -Xmx768M -jar cytoscape.jar -p plugins %*
GOTO end

:: We end up here if we have a Cytoscape.vmoptions file:
:itIsThere
:: Read vmoptions, one per line.
setLocal EnableDelayedExpansion
for /f "tokens=* delims= " %%a in (Cytoscape.vmoptions) do (
set /a N+=1
set opt!N!=%%a
)

java !opt1! !opt2! !opt3! !opt4! !opt5! !opt6! !opt7! !opt8! !opt9! -jar cytoscape.jar -p plugins %*


:end
