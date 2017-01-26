#!/bin/bash

if [ $# != 1 ]; then
	echo "error!!"
	echo "Usage: ntfsunmount [disk_name]"
	exit -1
fi

disk_name="$1"
device_node=`diskutil info ${disk_name} | grep 'Device Node' | cut -d : -f 2 | sed 's/^[[:space:]]*//' | sed 's/[ \t]*$//g'`

mounted_path="/Volumes/${disk_name}"

sudo diskutil unmount "${mounted_path}"

link_path=~/Desktop/${disk_name}
echo ${link_path}
if [ ! -L ${link_path} ]; then
	echo "${link_path} not exist"
	exit 0
else
	echo "remove link file"
	rm ${link_path}
	exit 0
fi