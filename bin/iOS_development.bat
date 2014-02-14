set java_dir="C:\Program Files (x86)\Java\jre7\bin\java.exe"
set adt_directory="C:\SDK\AIR\air4.0\lib\adt.jar"
set signing_provisioning_options=-storetype pkcs12 -keystore "C:\Users\John\Documents\GitHub\PhotoQuest\src\certificates\pixelutopiaIOS.p12" -storepass Nopeeking1 -provisioning-profile "C:\Users\John\Documents\GitHub\SlidingCars\bin\cert\SlidingCars_development.mobileprovision"

%java_dir% -jar %adt_directory% -package -target ipa-debug %signing_provisioning_options% slidingCars.ipa slidingCars-app.xml slidingCars.swf icons runtimeAssets
@pause