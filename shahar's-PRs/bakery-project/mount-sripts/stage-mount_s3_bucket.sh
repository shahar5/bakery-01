#!/bin/bash
# this script suppose to mount s3 bucket (aws) on ec2 instance with ubuntu as os
# MOUNT_POINT if the dir "bucket" already exist, suppose to happen in existing instance
# so this check meant to deny overwrite data
MOUNT_POINT=$(ls -la /home/ubuntu/ | grep bucket  > /tmp/mp-check.txt && cat /tmp/mp-check.txt | awk '{print $9}')
# AWS_CREDS get value on build from jenkins creds
AWS_CREDS=$1
# run only if $MOUNT_POINT is NULL
if [ -z "$MOUNT_POINT" ]; then
  rm /tmp/mp-check.txt
  sudo apt update
  sudo apt install s3fs -y
  echo $AWS_CREDS > /home/ubuntu/.passwd-s3fs
  chmod 600 /home/ubuntu/.passwd-s3fs
  mkdir /home/ubuntu/$s3_folder_path
  s3fs bakery-bucket-2 /home/ubuntu/$s3_folder_path
fi
