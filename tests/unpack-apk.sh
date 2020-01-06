#!/bin/sh
#usage: ./unpack.sh <apk-file>
#1. unpackage the apk file
APKfile=$1
#APKdir=$(basename $APKfile .apk)
echo "unzip the apk file"
java -jar /Users/rrachapa/Desktop/HybridPaper/ud-uncc-mobsec/tools/apktool_2.2.1.jar d -s -f $APKfile
#option -o <dir> to generate to the <dir> folder
