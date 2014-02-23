set java_loc=C:\Program Files (x86)\Java\jre7\bin\java.exe
set adt_loc=C:\SDK\AIR\air4.0\lib\adt.jar
set project_dir=C:\Users\John\Documents\GitHub\PhotoQuest\bin\deviceRelease\iosRelease


"%java_loc%" -jar "%adt_loc%"  -uninstallApp -platform ios  -appid com.pixelutopia.photoquest
"%java_loc%" -jar "%adt_loc%" -installApp -platform ios  -package "%project_dir%"\PhotoQuest_ios_debug.ipa

echo aY | choice /n

pause
