#!/bin/bash
findc(){
     cd "$1"
     for line in *
     do
           if [ -d "$line" ];
           then	
		findc "$line" 
           fi
     done
     for line in *
     do
           if [ -f "$line" ]
           then
                check=`echo -n "$line" | grep '.?*\.c$'| wc -l` 
                if [ $check -ne 0 ];
		then
			var1=`awk -f "$curd"/awk_script.awk "$line"`
			output=($var1)
			comments=output[0]
			totalcomments=$(($comments+$totalcomments))
			strings=output[1]
			totalstrings=$(($strings+$totalstrings))
		fi
           fi
     done
     cd ..   
}


if [ $# -ne 1 ];
then
   echo "usage: $0 <csv-file> <dir-path>" 
   exit -1
fi

totalcomments=0

totalstrings=0

curd=`pwd`

findc "$1"

echo "$totalcomments lines of comments"
echo "$totalstrings lines of strings"
