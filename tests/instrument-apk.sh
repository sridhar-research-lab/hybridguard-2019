#!/bin/sh
#usage: ./instrument-apk.sh <apk-file> <aspectj>
#use ud-uncc-mobsec.keystore to sign the apk.
#output: secure-<apk-file>
#Step 1. unpackage the apk file
rm classes*.jar
rm classes*.dex
APKfile=$1

APKdir=$(basename $APKfile .apk)
echo "UD-UNCC-mobsec: unpack the apk file"
java -jar ../tools/apktool_2.2.1.jar d -s -f $APKfile
#option -o <dir> to generate to the <dir> folder

for DEXfile in $APKdir/*.dex 
do
    #echo $DEXfile
    #Step 2: Covert the "classes.dex" to a jar file:
    classname=$(basename $DEXfile .dex)
    echo "UD-UNCC-mobsec: coverting the \"$DEXfile\" to \"$classname-dex2jar.jar\" file"
    sh ../tools/dex2jar/d2j-dex2jar.sh $DEXfile --force

    #Step 3: Weave AspectJ code into the jar file:
    echo "UD-UNCC-mobsec: Weaving AspectJ code into \"$classname-dex2jar.jar\" file, producing \"$classname.jar\""
    injar=$classname-dex2jar.jar
    aspectj=$2
    java -cp ../tools/aspectjtools.jar org.aspectj.tools.ajc.Main -cp ../tools/aspectjrt.jar:../tools/android.jar -inpath $injar -outjar $classname.jar $aspectj

    if [ -f $classname.jar ] ; then
        echo "UD-UNCC-mobsec: Adding the aspectj libraries (aspectjrt.jar and aspectjweaver.jar) \"$classname.jar\""
        jar -uf $classname.jar org/
        else
        echo "Errors with AspectJ weaving. Exiting..."
        exit 0;
    fi  


    #Step 4: Convert the modified jar file to .dex file:
    echo "UD-UNCC-mobsec: Convert the modified jar file \"$classname.jar\" to \"$APKdir/$classname.dex\" file "
    sh ../tools/dex2jar/d2j-jar2dex.sh $classname.jar --force -o $classname.dex

    if [ -f $classname.dex ] ; then

        echo "UD-UNCC-mobsec: Replacing the modified \"$APKdir/$classname.dex\""
        rm $APKdir/$classname.dex
        cp $classname.dex $APKdir/$classname.dex
        else
        echo "Errors in coverting \"$classname.jar\" to \"$classname.dex\". Exiting..."
        exit 0;
    fi


done 

mkdir -p apks-secured

#Step 5: Repacking the apk file with the modified "classes-jar2dex.dex": 

echo "UD-UNCC-mobsec: Repackaging the directory $APKdir to new APK file \"apks-secured/secured-$APKdir.apk\" ......"
java -jar ../tools/apktool_2.2.1.jar b $APKdir -o apks-secured/secured-$APKdir.apk

#Step 6: Sign the new apk file:
echo "UD-UNCC-mobsec: checking if the certificate exists..."
if [ -f ud-uncc-mobsec.keystore ] ; then
    echo "UD-UNCC-mobsec: using existing 'ud-uncc-mobsec.keystore' certificate..."
else
    echo "UD-UNCC-mobsec: ud-uncc-mobsec.keystore does not exists."
    echo "Use the following cmd to generate the certificate:"
    echo "keytool -alias ud-uncc-mobsec -genkey -v -keystore ud-uncc-mobsec.keystore -keyalg RSA -keysize 2048 -validity 10000"
    exit 0;
fi	
echo "UD-UNCC-mobsec: signing the new apk \"apks-secured/secured-$APKdir.apk\""
jarsigner -verbose -keystore ud-uncc-mobsec.keystore apks-secured/secured-$APKdir.apk ud-uncc-mobsec
#Calls jarsigner to sign with the generated ud-uncc-mobsec.keystore (use the file name without hyphen as the Passphase).

