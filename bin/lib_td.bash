#!/bin/bash
source lib_td_const.bash
if [ $1 = $message_1 ];then
    cp $dir$notYet $dir$tempFile_1
    echo $(date +%y%m%d%H%M%S):${@#$message_1} > $dir$notYet
    cat $dir$tempFile_1 >> $dir$notYet
    rm -f $dir$tempFile_1
    touch $dir$tempFile_1
elif [ $1 = $message_2 ];then
    echo input number of finished todo
    cat -n $dir$notYet
    read number
    while [[ $number = [0-9]* ]];do
	i=1
	cat $dir$notYet | while read line;do
	    if [ $i -ne $number ];then
		echo $line >> $dir$tempFile_1
	    else
		cp $dir$finished $dir$tempFile_2
		echo $(date +%y%m%d%H%M%S)_$line > $dir$finished
		cat $dir$tempFile_2 >> $dir$finished
		rm -f $dir$tempFile_2
		touch $dir$tempFile_2
	    fi
	    i=$[$i+1]
	done
	cp $dir$tempFile_1 $dir$notYet
	rm -f $dir$tempFile_1
	touch $dir$tempFile_1
	echo input number of finished todo
	cat -n $dir$notYet
	read number
    done
fi
