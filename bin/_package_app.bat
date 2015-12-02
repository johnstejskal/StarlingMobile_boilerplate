@echo off

:setup
set PAUSE_ERRORS=1
set JAVA_DIR="C:\Program Files (x86)\Java\jre1.8.0_45\bin\java.exe"
set ADT_DIR="C:\Users\ben\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+19.0.0\lib\adt.jar"
set ADB_DIR="C:\Users\ben\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+19.0.0\lib\android\bin\adb.exe"
set IP_WORK=192.168.10.169
set IP_HOME=10.1.1.8
set CERT_IOS="..\cert\client\ios_distribution.p12"
set CERT_ANDROID="..\cert\client\3rd_Sense_Android.p12"
set PROV_ADHOC="..\cert\client\SWSLHD_Blood_Battles_AdHoc.mobileprovision"
set PROV_APPSTORE=""
set PASS_IOS=suzie7
set PASS_ANDROID=suzie7
set XML_IOS=app-ios.xml
set XML_ANDROID=app-android.xml
setlocal enabledelayedexpansion
set SPLASH=
for /r . %%g in (en.lproj\*.png) do set SPLASH=!SPLASH! %%~nxg
set PACKAGE_IOS=main.swf %SPLASH% icons lib runtimeAssets notification.caf
set PACKAGE_ANDROID=main.swf runtimeAssets lib icons
set EXTENSION_DIR=ane
set APP_ID_ANDROID=au.gov.nsw.swslhd.bloodbattles
set APP_ID_IOS=au.gov.nsw.swslhd.bloodbattles

:menu
echo.
echo Package for target
echo.
echo Android:
echo -------------------------------------------------
echo  [0] normal       (apk-captive-runtime)
echo  [1] debug        (apk-debug :: WORK)
echo  [2] debug        (apk-debug :: HOME)
echo  [3] x86          (apk-captive-runtime :: x86)
echo.
echo iOS:
echo -------------------------------------------------
echo  [4] ad hoc       (ipa-ad-hoc)
echo  [5] debug        (ipa-debug :: WORK)
echo  [6] debug        (ipa-debug :: HOME)
echo  [7] app store    {ipa-app-store)
echo  [10] simulator   {ipa-test-interpreter-simulator}
echo.
echo Installation Only
echo -------------------------------------------------
echo  [8] Install to Android
echo  [9] Install to iOS
echo.
:choice
set /P C=[Choice]: 
echo.

:logic
set APP_ID=%APP_ID_ANDROID%
if %C% GTR 3 set APP_ID=%APP_ID_IOS%
if "%C%"=="8" set APP_ID=%APP_ID_ANDROID%

set CERT=%CERT_ANDROID%
set PASS=%PASS_ANDROID%
set PROV=
set ARCH=
set IP=
set OUTPUT=%APP_ID%.apk
set XML=%XML_ANDROID%
set PACKAGE=%PACKAGE_ANDROID%

set EXTENSION=-extdir %EXTENSION_DIR%
if "%EXTENSION_DIR%"=="" set EXTENSION=

if "%C%"=="8" goto android-install

if %C% GTR 3 set PACKAGE=%PACKAGE_IOS%
if %C% GTR 3 set XML=%XML_IOS%
if %C% GTR 3 set OUTPUT=%APP_ID%.ipa
if %C% GTR 3 set CERT=%CERT_IOS%
if %C% GTR 3 set PROV=-provisioning-profile %PROV_ADHOC%
if %C% GTR 3 set PASS=%PASS_IOS%
if %C% GTR 6 set PROV=-provisioning-profile %PROV_APPSTORE%

if "%C%"=="0" set TARGET=apk-captive-runtime
if "%C%"=="1" set TARGET=apk-debug
if "%C%"=="1" set IP=-connect %IP_WORK%
if "%C%"=="2" set TARGET=apk-debug
if "%C%"=="2" set IP=-connect %IP_HOME%
if "%C%"=="3" set TARGET=apk-captive-runtime
if "%C%"=="3" set ARCH=-arch x86
if "%C%"=="4" set TARGET=ipa-ad-hoc
if "%C%"=="5" set TARGET=ipa-debug
if "%C%"=="5" set IP=-connect %IP_WORK%
if "%C%"=="6" set TARGET=ipa-debug
if "%C%"=="6" set IP=-connect %IP_HOME%
if "%C%"=="7" set TARGET=ipa-app-store
if "%C%"=="7" set OUTPUT=%APP_ID%-appstore.ipa
if "%C%"=="9" set OUTPUT=%APP_ID%.ipa
if "%C%"=="9" goto ios-install
if "%C%"=="10" set TARGET=ipa-test-interpreter-simulator

:splash-copy
if %C% LSS 4 goto compile
@echo Copying iOS splash files
xcopy en.lproj\*.png

:compile
@echo Packing %APP_ID% in to a binary
echo.
call %JAVA_DIR% -jar %ADT_DIR% -package -target %TARGET% %IP% %ARCH% -storetype pkcs12 -keystore %CERT% -storepass %PASS% %PROV% %OUTPUT% %XML% %PACKAGE% %EXTENSION%
if errorlevel 1 goto packagefail
@echo off
if %C% GTR 3 goto ios-install

:android-install
@echo on
:: %JAVA_DIR% -jar %ADT_DIR% -uninstallApp -platform android -appid %APP_ID%
%ADB_DIR% -d install -r %OUTPUT%
@echo off
goto end

:ios-install
if "%C%"=="7" goto end

@echo on
%JAVA_DIR% -jar %ADT_DIR% -installApp -platform ios -package %OUTPUT%
@echo off
if "%C%"=="9" goto end 
goto splash-delete

:packagefail
echo.
echo Packing %APP_ID% failed!
echo.
goto splash-delete

:splash-delete

if %C% LSS 4 goto end
for /r . %%g in (en.lproj\*.png) do del %%~nxg

:end
pause