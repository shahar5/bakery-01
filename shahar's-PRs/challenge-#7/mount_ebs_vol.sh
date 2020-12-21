#!/bin/bash

DEVICE=/dev/xvdh
FS_TYPE=$(file -s $DEVICE | awk '{print $2}')
MOUNT_POINT=/home/ubuntu/data

# If no FS, then this output contains "data"
if [ "$FS_TYPE" = "data" ]; then
    echo "Creating file system on $DEVICE"
    mkfs -t xfs $DEVICE
fi

mkdir $MOUNT_POINT
mount $DEVICE $MOUNT_POINT
echo ${DEVICE} '/home/ubuntu/data xfs defaults 0 0' >> /etc/fstab
