#!/bin/sh
#usage: ./dex2jar.sh <apk-file>
#1. unpackage the apk file
DEXfile=$1
sh ../tools/dex2jar/d2j-dex2jar.sh $DEXfile