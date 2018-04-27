#!/bin/bash

cdd() {
    cd $1
}

file=$1

filename="random"
dirname="random"
`mkdir "answer"`
`cp $file 'answer'`
cdd "answer"
NN=943434728472

while IFS='' read -r line || [[ -n "$line"  ]]; do
    data=`echo $line`
    if [ "$dirname" == "findthename" ]; then
        dirname=`echo "$data" | grep -o -P '(?<=\<name\>).*(?=\</name\>)'`
        `mkdir $dirname`
        `cp $file $dirname`
        cdd $dirname
        # get the dir name mkdir and cd
    elif [ "$filename" == "findthename" ]; then
        filename=`echo "$data" | grep -o -P '(?<=\<name\>).*(?=\</name\>)'`
        # store the value in filename
        filesize=$NN
        # to get filesize in next step
    elif [[ ( $filesize -eq $NN ) ]]; then
        filesize=`echo "$data" | grep -o -P '(?<=\<size\>).*(?=\</size\>)'`
        filesize=$(( $filesize + 0  )) #converting to int
    elif [ "$data" == "<dir>" ]; then
        dirname="findthename"
    elif [ "$data" == "</dir>" ]; then
        `rm $file`
        cdd ".."
        # move to parent directory
    elif [ "$data" == "<file>" ]; then
        filename="findthename"
    elif [ "$data" == "</file>" ]; then
        echo $filename
        `dd if=/dev/zero of="$filename" bs=$filesize count=1`
    fi
done < "$file"

`rm $file`
