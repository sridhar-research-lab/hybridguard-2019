injar=$1
aspectj=$2
java -cp ../tools/aspectjtools.jar org.aspectj.tools.ajc.Main -cp ../tools/aspectjrt.jar:../tools/android.jar -inpath $injar -outjar classes.jar $aspectj -showWeaveInfo -log weavinglog.txt -progress
#add the aspectj libraries to classes.jar
#jar -uf classes.jar org/
