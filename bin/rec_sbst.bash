#!/bin/bash
# rec_sbst.bash 置換対ファイル 対象拡張子
# 置換対ファイルに書かれた対に従って対象拡張子のファイルを再帰的に置換する．
fileName=$1
extension=$2
oldifs=$IFS
IFS=$'\t'
set | grep -i ifs
cat $fileName | while read line
do
    echo rsed.bash $line $extension
    rsed.bash $line $extension
done
IFS=$oldifs
