set adt_directory=C:\SDK\AIR\air3.9\bin
set signing_provisioning_options=-storetype pkcs12 -keystore pixelutopiaIOS.p12 -storepass Nopeeking1 -provisioning-profile SlidingCars_development.mobileprovision

"%adt_directory%"\adt -package -target ipa-ad-hoc %signing_provisioning_options% SlidingCars.ipa slidingCars-app.xml slidingCars.swf icons runtimeAssets Default.png Default@2x.png
@pause