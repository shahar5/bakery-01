#!/bin/bash
# this script suppose to mount ebs volume (aws) on ec2 machine with ubuntu as os
data_folder_path=$1
nexus_user=$2
nexus_pass=$3
nexus_ip=$4
DEVICE=/dev/xvdh
FS_TYPE=$(sudo file -s $DEVICE > /tmp/fs-test.txt && cat /tmp/fs-test.txt | awk '{print $2}')
MOUNT_POINT=/home/ubuntu/$data_folder_path
# DIR_CHECK cehcks if the dir "data" already exist, suppose to happen in existing instance
# so this check meant to deny overwrite data
DIR_CHECK=$(ls -la /home/ubuntu/ | grep data > /tmp/dir-check.txt && cat /tmp/dir-check.txt | awk '{print $9}')

# if there's no FS on ebs volume, then this output contains "data"
if [ "$FS_TYPE" = "data" ]; then
    rm /tmp/fs-test.txt
    echo "Creating file system on $DEVICE"
    sudo mkfs -t xfs $DEVICE
fi
# run only if $DIR_CHECK is NULL
if [ -z "$DIR_CHECK" ]; then
  mkdir $MOUNT_POINT
  sudo mount $DEVICE $MOUNT_POINT
  sudo sh -c "echo '${DEVICE} /home/ubuntu/data xfs defaults 0 0' >> /etc/fstab"
  sudo chown ubuntu $MOUNT_POINT
  sudo chmod 775 $MOUNT_POINT
  date >> $MOUNT_POINT/ebs-textfile.txt
  curl -X GET -u $nexus_user:$nexus_pass http://$nexus_ip:8081/nexus/content/repositories/test/nexus_txt_file/txt_from_nexus.txt -O
  mv txt_from_nexus.txt $MOUNT_POINT/txt_from_nexus.txt
fi
