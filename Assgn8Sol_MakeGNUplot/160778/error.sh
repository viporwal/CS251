#!/bin/bash
flag=0
for i in 1 2 4 8 16
do
	prev_num=-1;
	sum=0;
	sq=0;
	counter=0;

	while read line;
	do
		num_elements=`echo $line | cut -d " " -f1 | bc`
		time=`echo $line | cut -d " " -f2 | bc`
		if [ $num_elements -ne $prev_num ]
		then
			if [ $prev_num -ne -1 ]
			then
				average=`echo "scale=4 ; $sum / $counter" | bc`
				y=`echo "scale=4 ; $average * $average" | bc`
				variance=`echo "scale=4 ; $sq / $counter" | bc`
				variance=`echo "scale=4 ; $variance - $y" | bc`
				if [ $flag -ne 1 ]
				then
					echo $prev_num $average $variance > error$i.out
					flag=1
				else
					echo $prev_num $average $variance >> error$i.out
				fi
			fi
			prev_num=$num_elements
			sum=0
			sq=0
			counter=0
		fi
		sum=$((sum + time))
		x=$((time * time))
		sq=$((sq + x))
		counter=$((counter + 1))
	done < thread$i.out

	if [ $counter -ne 0 ]
	then
		average=`echo "scale=4 ; $sum / $counter" | bc`
		y=`echo "scale=4 ; $average * $average" | bc`
		variance=`echo "scale=4 ; $sq / $counter" | bc`
		variance=`echo "scale=4 ; $variance - $y" | bc`
		if [ $flag -ne 1 ]
		then
			echo $prev_num $average $variance > error$i.out
			flag=1
		else
			echo $prev_num $average $variance >> error$i.out
		fi
	fi

	prev_num=-1;
	sum=0;
	sq=0;
	counter=0;
	flag=0
done

exec 3< error1.out
exec 4< error2.out
exec 5< error4.out
exec 6< error8.out
exec 7< error16.out

mark=0

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
    variance1=`echo $line1 | cut -d " " -f3 | bc`
    variance2=`echo $line2 | cut -d " " -f3 | bc`
    variance3=`echo $line3 | cut -d " " -f3 | bc`
    variance4=`echo $line4 | cut -d " " -f3 | bc`
    variance5=`echo $line5 | cut -d " " -f3 | bc`
    if [ $mark -ne 1 ]
    then
    	echo $num_elements 1 $avg2 $avg3 $avg4 $avg5 $variance1 $variance2 $variance3 $variance4 $variance5 > error.out
    	mark=1
    else
    	echo $num_elements 1 $avg2 $avg3 $avg4 $avg5 $variance1 $variance2 $variance3 $variance4 $variance5 >> error.out
    fi
done

exec 3<&-
exec 4<&-
exec 5<&-
exec 6<&-
exec 7<&-

rm error1.out
rm error2.out
rm error4.out
rm error8.out
rm error16.out