set java_loc=C:\Program Files (x86)\Java\jre7\bin\java.exe
set adt_loc=C:\SDK\AIR\air4.0\lib\adt.jar
set project_dir=C:\Users\John\Documents\GitHub\SlidingCars\bin


"%java_loc%" -jar "%adt_loc%"  -uninstallApp -platform ios  -appid com.pixelutopia.slidingcars
"%java_loc%" -jar "%adt_loc%" -installApp -platform ios  -package "%project_dir%"\slidingCars.ipa

echo aY | choice /n

pause
