#!/bin/bash
printtree(){
     cd "$1"
     for line in *
     do
           if [ -d "$line" ];
           then	
		printtree "$line" 
           fi
     done
     for line in *
     do
           if [ -f "$line" ]
           then
                check=`echo -n "$line" | grep '.?*\.c'| wc -l` 
                if [ $check -ne 0 ];
		then
			comments=`awk -f awkcomment.awk "$line" `
			totalcomments+=$comments
			strings=`awk -f awkstr.awk "$line" `
			totalstrings+=$strings
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

printtree $1

echo "$totalcomments lines of comments\n"
echo "$totalstrings lines of strings\n"
