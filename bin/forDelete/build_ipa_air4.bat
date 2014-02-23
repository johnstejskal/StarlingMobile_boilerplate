set java_dir="C:\Program Files (x86)\Java\jre7\bin\java.exe"
set adt_directory="C:\Program Files\Adobe\Adobe Flash CC\AIR 4.0\lib\adt.jar"
set signing_provisioning_options=-storetype pkcs12 -keystore "C:\Users\ben\Documents\Clients\Incubator\Git\coles-cofv-as\src\certs\thirdsense\3RD_Sense_iOS_Developer.p12" -storepass suzie7 -provisioning-profile "C:\Users\ben\Documents\Clients\Incubator\Git\coles-cofv-as\src\certs\thirdsense\Coles_COFV_Development.mobileprovision"

%java_dir% -jar %adt_directory% -package -target ipa-ad-hoc -useLegacyAOT no %signing_provisioning_options% ColesCOFV.ipa ColesCOFV-air4.xml ColesCOFV.swf Default.png Default@2x.png Default-568h@2x.png Default-Portrait.png icons lib
@pause