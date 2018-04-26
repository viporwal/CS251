#!/bin/bash
indent=0
pindent(){
            i=0
            while [ $i -lt $indent ];
            do
                  echo -n "   "
                  i=$(($i+1))
            done 
}
printtree(){
     cd "$1"
     for line in *
     do
           if [ -d "$line" ];
           then
                indent=$(($indent + 1))
		pindent

		echo -n "(D) "
		echo -n "$line"
		separatord=0
               	separatord=`grep -ro '\.\|\!\|\?' "$line" | wc -l`
		echo -n "-"
		floatd=0
		floatd=`grep -ro '[0-9]\+\.[0-9]\+' "$line" | wc -l`
		sentenced=$(($separatord - $floatd))
	 	echo -n "$sentenced"
		totalintd=0
		totalintd=`grep -ro '[0-9]\+' "$line" | wc -l`
		echo -n "-"
		tosubd=$((floatd * 2))
		intd=$(($totalintd - $tosubd))
		echo "$intd"
		
		printtree "$line" 
           fi
     done
     for line in *
     do
           if [ -f "$line" ]
           then
           	indent=$(($indent + 1))
                pindent
		echo -n "(F) "
                echo -n "$line"
		separatorf=0
                separatorf=`grep -o '\.\|\!\|\?' "$line" | wc -l`
		echo -n "-"
		floatf=0
		floatf=`grep -o '[0-9]\+\.[0-9]\+' "$line" | wc -l`
		sentencef=$(($separatorf - $floatf))
	 	echo -n "$sentencef"
	       	totalintf=0
		totalintf=`grep -o '[0-9]\+' "$line" | wc -l`
		echo -n "-"
		tosubf=$((floatf * 2))
		intf=$(($totalintf - $tosubf))
		echo "$intf"
                
		indent=$(($indent - 1)) 
           fi
     done
     cd ..   
     indent=$(($indent - 1))
}


if [ $# -ne 1 ];
then
   echo "usage: $0 <csv-file> <dir-path>" 
   exit -1
fi

printtree $1

echo -n "(D) "
echo -n "$1"
separator=0
separator=`grep -ro '\.\|\!\|\?' "$1" | wc -l`
echo -n "-"
float=0
float=`grep -ro '[0-9]\+\.[0-9]\+' "$1" | wc -l`
sentence=$(($separator - $float))
echo -n "$sentence"
totalint=0
totalint=`grep -ro '[0-9]\+' "$1" | wc -l`
echo -n "-"
tosub=$((float * 2))
int=$(($totalint - $tosub))
echo "$int"

