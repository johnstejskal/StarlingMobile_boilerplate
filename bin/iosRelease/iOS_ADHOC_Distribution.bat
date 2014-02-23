set java_dir="C:\Program Files (x86)\Java\jre7\bin\java.exe"
set adt_directory="C:\SDK\AIR\air3.9\lib\adt.jar"
set signing_provisioning_options=-storetype pkcs12 -keystore "certs\pixelutopiaIOS.p12" -storepass Nopeeking1 -provisioning-profile "certs\PhotoQuest_development.mobileprovision"

%java_dir% -jar %adt_directory% -package -target ipa-ad-hoc %signing_provisioning_options% PhotoQuest.ipa photoquest_ios_development.xml photoquest.swf icons-ios certs Default.png Default-568h@2x.png Default-Landscape.png Default-Landscape@2x.png
@pause