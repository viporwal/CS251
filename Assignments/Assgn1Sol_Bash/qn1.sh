#!/bin/bash
ones(){
case $1 in
	1)
		echo "one" >> ofile
	;;
	2)
		echo "two" >> ofile
	;;
	3)
		echo "three" >> ofile
	;;	
	4)
		echo "four" >> ofile
	;;
	5)	
		echo "five" >> ofile
	;;
	6)
		echo "six" >> ofile
	;;
	7)
		echo "seven" >> ofile
	;;
	8)
		echo "eight" >> ofile
	;;
	9)
		echo "nine" >> ofile
	;;
esac	
}

tens(){
case $1 in
	10)
		echo "ten" >> ofile
	;;
	11)
		echo "eleven" >> ofile
	;;
	12)
		echo "twelve" >> ofile
	;;
	13)
		echo "thirteen" >> ofile
	;;	
	14)
		echo "fourteen" >> ofile
	;;
	15)	
		echo "fifteen" >> ofile
	;;
	16)
		echo "sixteen" >> ofile
	;;
	17)
		echo "seventeen" >> ofile
	;;
	18)
		echo "eighteen" >> ofile
	;;
	19)
		echo "nineteen" >> ofile
	;;
	2)
		echo "twenty" >> ofile
	;;
	3)
		echo "thirty" >> ofile
	;;	
	4)
		echo "forty" >> ofile
	;;
	5)	
		echo "fifty" >> ofile
	;;
	6)
		echo "sixty" >> ofile
	;;
	7)
		echo "seventy" >> ofile
	;;
	8)
		echo "eighty" >> ofile
	;;
	9)
		echo "ninety" >> ofile
	;;
esac
}

twod(){
	end1=$(($1%10))
	st1=$(($1/10))
	if [ $st1 -ne 1 ]
	then
		ones $end1
		tens $st1
	else
		s=$(($1%100))
		tens $s
	fi
}

threed(){
	st2=$(($1/100))
	left2=$(($1%100))
	twod $left2
	if [ $st2 -gt 0 ]
	then
		echo "hundred" >> ofile
	fi
	ones $st2
}

fourd(){
	st3=$(($1/1000))
	left3=$(($1%1000))
	threed $left3
	if [ $st3 -gt 0 ]
	then
		echo "thousand" >> ofile
	fi
	ones $st3
}

fived(){
	st4=$(($1/1000))
	left4=$(($1%1000))
	threed $left4
	if [  $st4 -gt 9 ]
	then
		echo "thousand" >> ofile
	fi
	twod $st4
}

sixd(){
	st5=$(($1/100000))
	left5=$(($1%100000))
	if [ $left5 -gt 9999 ]
	then
		fived $left5
	else
		fourd $left5
	fi
	if [ $st5 -gt 0 ]
	then
		echo "lakh" >> ofile
	fi
	ones $st5
}

sevend(){
	st6=$(($1/100000))
	left6=$(($1%100000))
	if [ $left6 -gt 9999 ]
	then
		fived $left6
	else
		fourd $left6
	fi
	if [  $st6 -gt 9 ]
	then
		echo "lakh" >> ofile
	fi
	twod $st6
}

eightd(){
	st7=$(($1/10000000))
	left7=$(($1%10000000))
	if [ $left7 -gt 999999 ]
	then
		sevend $left7
	else
		sixd $left7
	fi
	if [ $st7 -gt 0 ]
	then
		echo "crore" >> ofile
	fi
	ones $st7
}



a=$1
reg='^[0-9]+$'
if ! [[ $a =~ $reg ]] ;
then
	echo "invalid input"
	exit -1
fi

n=$( echo $a | sed 's/^0*//' )

dig=${#n}
if [ $dig -gt 11 ]
then
	echo "invalid input"
	exit -1
fi

if [ $dig = 0 ]
then 
	echo "zero" >> ofile
fi

case $dig in
	1)
		ones $n
	;;
	2)
		twod $n
	;;
	3)
		threed $n
	;;	
	4)
		fourd $n
	;;
	5)
		fived $n	
	;;
	6)
		sixd $n		
	;;
	7)
		sevend $n
	;;
	8)
		eightd $n
	;;
	9)
		ftwo=$((n/10000000))
		cr1=$((n%10000000))
		if [ $cr1 -gt 999999 ]
		then
		sevend $cr1
		else
		sixd $cr1
		fi
		echo "crore" >> ofile
		twod $ftwo
	;;
	10)
		fthree=$((n/10000000))
		cr2=$((n%10000000))
		if [ $cr2 -gt 999999 ]
		then
		sevend $cr2
		else
		sixd $cr2
		fi
		echo "crore" >> ofile
		threed $fthree
		
	;;
	11)
		ffour=$((n/10000000))
		cr3=$((n%10000000))
		if [ $cr3 -gt 999999 ]
		then
		sevend $cr3
		else
		sixd $cr3
		fi
		echo "crore" >> ofile
		fourd $ffour
	;;
esac

output=`tail -n 100 ofile | tac`
echo $output

del=`rm ofile`
