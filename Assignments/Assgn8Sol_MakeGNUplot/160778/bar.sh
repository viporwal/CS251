#!/bin/bash

exec 3< line1.out
exec 4< line2.out
exec 5< line4.out
exec 6< line8.out
exec 7< line16.out

flag=0

while IFS= read -r -u3 line1;
do
    IFS= read -r -u4 line2
    IFS= read -r -u5 line3
    IFS= read -r -u6 line4
    IFS= read -r -u7 line5
    num_elements=`echo $line1 | cut -d " " -f1 | bc`
    avg1=`echo $line1 | cut -d " " -f2 | bc`
    avg2=`echo $line2 | cut -d " " -f2 | bc`
    avg3=`echo $line3 | cut -d " " -f2 | bc`
    avg4=`echo $line4 | cut -d " " -f2 | bc`
    avg5=`echo $line5 | cut -d " " -f2 | bc`
    avg2=`echo "scale=4 ; $avg1 / $avg2" | bc`
    avg3=`echo "scale=4 ; $avg1 / $avg3" | bc`
    avg4=`echo "scale=4 ; $avg1 / $avg4" | bc`
    avg5=`echo "scale=4 ; $avg1 / $avg5" | bc`
    if [ $flag -ne 1 ]
    then
        echo $num_elements 1 $avg2 $avg3 $avg4 $avg5 > bar.out
        flag=1
    else
        echo $num_elements 1 $avg2 $avg3 $avg4 $avg5 >> bar.out
    fi
done

exec 3<&-
exec 4<&-
exec 5<&-
exec 6<&-
exec 7<&-