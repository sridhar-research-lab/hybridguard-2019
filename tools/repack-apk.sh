#!/bin/sh
#usage: ./inject-jsirm.sh <jsirm html file> <apk file>
#1. unpackage the apk file
#2. loop to the unpackage folder/assets for HTML files
#3. For each HTML file DO
   #3.1. rename the HTML file <filename.html> -> <filename>_original<.html>
   #3.2. copy the <jsirm html file> to <filename.html>
   #3.3. replace the text "to_be_repalaced.html" by <filename>_original<.html>
type apktool >/dev/null 2>&1 || { echo >&2 "The apktool does not exist. Please install the tool first: https://code.google.com/p/android-apktool/.  Aborting."; exit 1; }
IRMfile=$1
APKfile=$2
APKdir=$(basename $APKfile .apk)
echo "Unpackage the apk file using apktool"
apktool d -f $APKfile $APKdir 
recurse() {
 for file in "$1"/*;do
    if [ -d "$file" ];then
        recurse "$file"
    else
        # check for relevant files
        #echo "$file"
        #file --mime-type "$file" 
        if file --mime-type "$file" | grep -q html$; then
  			#echo "$file is HTML"
  			#rename it
  			#basehtml="`basename $file .html`"
  			#echo "basename=$basehtml"
  			#cdir="`pwd`"
  			#echo "pwd=$cdir"
  			dn=$(dirname $file)
  			fn=$(basename $file)
  			newfile="${dn}/original_${fn}"
  			newbasefile=$(basename $newfile)
        echo "newbasefile:$newbasefile"
  			mv $file $newfile
  			#cp $IRMfile $file 
        cat $IRMfile | sed -e "s/to_be_replaced_by_original_html/${newbasefile}/" > $file
        #echo "cat $IRMfile | sed -e 's/to_be_replaced_by_original_html/${newbasefile}/' > $file"
  		fi
    fi
 done
}
echo "Injecting IRM HTML files to existing HTML files in the unpackaged directory $APKdir/assets"
recurse $APKdir/assets
#Repackage the apk
echo "Repackaging the directory $APKdir to new APK file irm_$APKfile..."
apktool b $APKdir irm_$APKfile
echo "Checking if the key files exist."
if [ -f certificate.pem ] && [ -f key.pk8 ]; then
    echo "Files certificate.pem and key.pk8 exists. Use these keys to sign the APK file."
    echo "If you want to set up new keyss, delete the existing files certificate.pem and key.pk8"
else
    echo "Either file certificate.pem and or key.pk8 does not exists. Creating key files..."
#   keytool -genkey -v -keystore my-release-key.keystore -alias secured_app_with_policies -keyalg RSA -validity 10000 -tsacert
    openssl genrsa -out key.pem 1024
    openssl req -new -key key.pem -out request.pem
    openssl x509 -req -days 9999 -in request.pem -signkey key.pem -out certificate.pem
    openssl pkcs8 -topk8 -outform DER -in key.pem -inform PEM -out key.pk8 -nocrypt
fi
#echo "Signing the new apk file irm_$APKfile"
#jarsigner -verbose -keystore my-release-key.keystore irm_$APKfile secured_app_with_policies
echo "Signing the new apk file irm_$APKfile"
echo "Make sure that you have the signapk.jar in your classpath"
java -jar ~/tools/signapk.jar certificate.pem key.pk8 irm_$APKfile  signed_irm_$APKfile