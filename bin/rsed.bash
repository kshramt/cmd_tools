#!/bin/bash
# rsed: recursive sed
# $> rsed "from" "to" "extension"
#oldifs=$IFS
#IFS="$'\t'"
if [ $# -ne 3 ]; then
    echo "**"
    echo "rsed.bash: recursive sed"
    echo "$> rsed.bash \"from\" \"to\" \"extension\""
    echo "**"
else
    from_=$1
    to_=$2
    extension=$3
    fileset="'*.$extension'"
    eval find . -name $fileset | while read file
    do
#	echo "s|$from_|$to_|g $file  $file.tmp && mv $file.tmp $file"
	sed -e "s|$from_|$to_|g" $file > $file.tmp && mv $file.tmp $file
    done
fi
#IFS=$oldifs