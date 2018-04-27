#!/bin/bash
# set -x
indent=0


#used for indentation
pindent(){
            i=0
            while [ $i -lt $indent ];
            do
		 local t
                  echo -n "   "
                  i=$(($i+1))
            done 
}
cntI=0
cntS=0
recurse(){
     cd "$1"
     local dI=0
     local dS=0
     for line in *
     do
           if [ -d "$line" ];
           then
                indent=$(($indent + 1))
                local tI=$cntI
		local tS=$cntS
		local dN=$line
                recurse "$line"
                dI=$(($cntI-$tI))
                dS=$(($cntS-$tS))
                pindent
                echo "(D) $dN-$dS-$dI"
                
           fi
     done
     for line in *
     do
           if [ -f "$line" ]
           then
                Int=`cat "$line" | egrep -o '(^|\s*)[-+]?[0-9]+\.?[0-9]*(\s+|[.]?$)' | wc -l | cut -f1`
		Flt=`cat "$line" | egrep -o '(^|\s*)[-+]?[0-9]+\.[0-9]+(\s+|$)' | wc -l | cut -f1`
                Sent=`cat "$line" | egrep -o '\.|\!|\?' | wc -l | cut -f1`
		Int=$(($Int-$Flt))
		Sent=$(($Sent-$Flt))
                cntI=$(($cntI+$Int))
                dI=$(($dI+$Int))
                cntS=$(($cntS+$Sent))
                dS=$(($dS+$Sent))
                pindent
                echo "(F) $line-$Sent-$Int"
           fi
     done
     cd ..   
     indent=$(($indent - 1))
}


if [[ $# -ne 1 || ! -d $1 ]];
then
   echo "usage: $0 <dir>" 
   exit -1
fi

indent=$(($indent + 1))
recurse $1
pindent
echo "(D) $1-$cntS-$cntI"
# set +x
