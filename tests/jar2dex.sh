#!/bin/sh
#usage: ./jar2dex.sh <jar-file>
#1. unpackage the apk file
JARfile=$1
sh ../tools/dex2jar/d2j-jar2dex.sh $JARfile