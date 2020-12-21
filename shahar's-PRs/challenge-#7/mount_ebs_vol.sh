#!/bin/bash

DEVICE=/dev/$(lsblk -n | awk '$NF != "/" {print $1}')
FS_TYPE=$(file -s $DEVICE | awk '{print $2}')
MOUNT_POINT=/home/ubuntu/data

if [ "$DEVICE != /dev"]; then
  # If no FS, then this output contains "data"
  if [ "$FS_TYPE" = "data" ]; then
      echo "Creating file system on $DEVICE"
      mkfs -t xfs $DEVICE
  fi

  mkdir $MOUNT_POINT
  mount $DEVICE $MOUNT_POINT
  echo ${DEVICE} '/home/ubuntu/data xfs defaults 0 0' >> /etc/fstab

else
  echo "Something went wrong, check if volume exist on the VM"
fi
