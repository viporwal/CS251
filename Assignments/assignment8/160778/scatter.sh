#!/bin/bash

flag1=0
flag2=0
flag4=0
flag8=0
flag16=0

while read line;
do
	thread=`echo $line | cut -d " " -f1 | bc`
	num_elements=`echo $line | cut -d " " -f2 | bc`
	time=`echo $line | cut -d " " -f3 | bc`
	
	if [ $thread -eq 1 ]
	then
		if [ $flag1 -ne 1 ]
		then
			echo $num_elements $time > thread1.out
			flag1=1
		else
			echo $num_elements $time >> thread1.out
		fi
	fi

	if [ $thread -eq 2 ]
	then
		if [ $flag2 -ne 1 ]
		then
			echo $num_elements $time > thread2.out
			flag2=1
		else
			echo $num_elements $time >> thread2.out
		fi
	fi

	if [ $thread -eq 4 ]
	then
		if [ $flag4 -ne 1 ]
		then
			echo $num_elements $time > thread4.out
			flag4=1
		else
			echo $num_elements $time >> thread4.out
		fi
	fi

	if [ $thread -eq 8 ]
	then
		if [ $flag8 -ne 1 ]
		then
			echo $num_elements $time > thread8.out
			flag8=1
		else
			echo $num_elements $time >> thread8.out
		fi
	fi

	if [ $thread -eq 16 ]
	then
		if [ $flag16 -ne 1 ]
		then
			echo $num_elements $time > thread16.out
			flag16=1
		else
			echo $num_elements $time >> thread16.out
		fi
	fi
done < output