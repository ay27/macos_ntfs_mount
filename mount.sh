#!/bin/bash

if [ $# != 1 ]; then
	echo "error!!"
	echo "Usage: ntfsmount [disk_name]"
	exit -1
fi

disk_name="$1"
device_node=`diskutil info ${disk_name} | grep 'Device Node' | cut -d : -f 2 | sed 's/^[[:space:]]*//' | sed 's/[ \t]*$//g'`

# check if it's a ntfs device
fs_1=`diskutil info ${disk_name} | grep 'File System Personality' | cut -d : -f 2 | sed 's/^[[:space:]]*//' | sed 's/[ \t]*$//g'`

fs_2=`diskutil info ${disk_name} | grep 'Type (Bundle)' | cut -d : -f 2 | sed 's/^[[:space:]]*//' | sed 's/[ \t]*$//g'`

if [ "$fs_1" != "NTFS" ] && [ "$fs_2" != "ntfs" ]; then
	echo "error!!"
	echo "the given disk is an ${fs_1} device, not an NTFS device"
	exit -1
fi

mounted_path="/Volumes/${disk_name}"
# echo "mounted_path is ${mounted_path}"

sudo diskutil unmount "${mounted_path}"

sudo mkdir "${mounted_path}"
sudo mount -t ntfs -o rw,auto,nobrowse ${device_node} ${mounted_path}
if [ $? -eq 0 ]; then
	echo "mount success"
	ln -s ${mounted_path} ~/Desktop/${disk_name}
	echo "link to deskop"
else
	echo "mount error!!"
	exit -1
fi
