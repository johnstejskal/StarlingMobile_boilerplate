set java_dir="C:\Program Files (x86)\Java\jre7\bin\java.exe"
set adt_directory="C:\SDK\AIR\air4.0\lib\adt.jar"
set signing_provisioning_options=-storetype pkcs12 -keystore "C:\Users\John\Documents\GitHub\PhotoQuest\src\certificates\JohnStejskal_iOS.p12" -storepass Nopeeking1 -provisioning-profile "C:\Users\John\Documents\GitHub\PhotoQuest\src\certificates\PhotoQuest_development.mobileprovision"

%java_dir% -jar %adt_directory% -package -target ipa-debug %signing_provisioning_options% PhotoQuest_ios_debug.ipa PhotoQuest_iOS_compile-app.xml PhotoQuest_iOS_compile.swf icons-ios Default.png Default@2x.png Default-568h@2x.png Default-Landscape.png Default-Landscape@2x.png -extdir extensions
@pause