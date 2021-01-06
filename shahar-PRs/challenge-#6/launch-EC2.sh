#!/usr/bin/bash
# This script built to launch an instance in aws
# VPC
echo "creating VPC"
aws ec2 create-vpc --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=Bakery_VPC}]' --cidr-block 10.0.0.0/16
VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=Bakery_VPC --query Vpcs[].VpcId --output text)
# Subnet
echo "Subnet"
aws ec2 create-subnet --vpc-id $VPC_ID --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Bakery_SUBNET}]' --cidr-block 10.0.1.0/24
SUB_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query Subnets[].SubnetId --output text)
# Internet Gateway
echo "IG"
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=Bakery_IG}]'
IG_ID=$(aws ec2 describe-internet-gateways --filter Name=tag:Name,Values=Bakery_IG --query InternetGateways[].InternetGatewayId --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IG_ID
# Route Table
echo "RT"
RT_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query RouteTables[].RouteTableId --output text)
echo "$RT_ID"
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IG_ID
aws ec2 associate-route-table --subnet-id $SUB_ID --route-table-id $RT_ID
aws ec2 modify-subnet-attribute --subnet-id $SUB_ID --map-public-ip-on-launch
# Key Pair
echo "KEY"
path=$(pwd)
aws ec2 create-key-pair --key-name Bakery_Key --query "KeyMaterial" --output text > "$path/Bakery_Key.pem"
# Security group
echo "SG"
SG_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query SecurityGroups[].GroupId --output text)
aws ec2 revoke-security-group-ingress --group-id $SG_ID --ip-permissions "$(aws ec2 describe-security-groups --group-ids $SG_ID --query SecurityGroups[].IpPermissions[])"
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
# launch an `Amazon Linux 2 AMI` free tier instance
echo "launch"
aws ec2 run-instances --image-id ami-0e9c91a3fc56a0376 --count 1 --instance-type t2.micro --key-name Bakery_Key --security-group-ids $SG_ID --subnet-id $SUB_ID
# SSH
EC2_IP=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID" --query Reservations[].Instances[].PublicIpAddress --output text)
echo "Instance IP: $EC2_IP, Do you want to make a connection?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) ssh -i "$path/Bakery_Key.pem" ec2-user@$EC2_IP;break;;
        No ) echo -e "I've done enough, I want coffee break";exit;;
    esac
done
