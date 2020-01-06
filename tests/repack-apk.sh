APKdir=$1
if [ -f classes-jar2dex.dex ] ; then
    echo "Copying classes-jar2dex.dex to $APKdir"
    cp classes-jar2dex.dex $APKdir/classes.dex
else
    echo "classes-jar2dex.dex does not exists, try previous steps to create one"
    exit 0;
fi

echo "Repackaging the directory $APKdir to new APK file ......"
java -jar ../tools/apktool_2.2.1.jar b $APKdir -o secured-$APKdir.apk
