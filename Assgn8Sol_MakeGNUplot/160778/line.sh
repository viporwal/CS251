#!/bin/bash

flag=0
for i in 1 2 4 8 16
do
	prev_num=-1;
	sum=0;
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
				if [ $flag -ne 1 ]
				then
					echo $prev_num $average > line$i.out
					flag=1
				else
					echo $prev_num $average >> line$i.out	
				fi
			fi
			prev_num=$num_elements
			sum=0
			counter=0
		fi
		sum=$((sum + time))
		counter=$((counter + 1))
	done < thread$i.out

	if [ $counter -ne 0 ]
	then
		average=`echo "scale=4 ; $sum / $counter" | bc`
		if [ $flag -ne 1 ]
		then
			echo $prev_num $average > line$i.out
			flag=1
		else
			echo $prev_num $average >> line$i.out	
		fi
	fi

	prev_num=-1;
	sum=0;
	counter=0;
	flag=0;
done
