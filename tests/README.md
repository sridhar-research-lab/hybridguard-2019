This folder contains shellscripts to inject IRM code written in AspectJ to an apk file.

Step 1: Unpack the apk to a directory, use 
$./unpack-apk.sh <apk-file>

This script will invoke apktool 
(java -jar ../tools/apktool_2.2.1.jar d -s -f <apk-file>) 
to perform the unpacking the apk file with resource files/folders and a "classes.dex"

Step 2: Covert the "classes.dex" to a jar file:
$./dex2jar.sh <path-to-apk-folder>/classes.dex

This script runs "../tools/dex2jar/d2j-dex2jar.sh $DEXfile" that 
converts the dex file to a jar file "classes-dex2jar.jar" in the current directory.

Step 3: Weave AspectJ code into the jar file:
$./aspect-weaver.sh <classes-dex2jar.jar> <aspectjfile>

This script invokes the AspectJ compiler to weave the AspectJ code to the jar file, and generate the modified jar file to "classes.jar" The command to run: 
"java -cp ../tools/aspectjtools.jar org.aspectj.tools.ajc.Main -cp ../tools/aspectjrt.jar:../tools/android.jar -inpath <classes-dex2jar.jar> -outjar classes.jar <aspectjfile>"

Step 4: Convert the modified jar file to .dex file:
$./jar2dex.sh classes.jar

This script  calls "../tools/dex2jar/d2j-jar2dex.sh <jar-file>" that 
converts the jar file back to a dex file "classes-jar2dex.dex" in the current directory.


Step 5: Repacking the apk file with the modified "classes-jar2dex.dex": 
$./repack-apk.sh <apk-folder>

This script will copy the modified "classes-jar2dex.dex" to the <apk-folder>, 
invokes the apktool to repack the apk and generate a new apk file.

Step 6: Sign the new apk file:
$./sign-apk .sh <apk-file>

Calls jarsigner to sign with the generated ud-uncc-mobsec.keystore (use the file name without hyphen as the Passphase).


