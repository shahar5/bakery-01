# terraform
variable "tf-version" {
  default = ">= 0.12.0"
}

# aws
variable "region" {
  default = "us-east-1"
}
variable "aws-profile" {
  default = "default"
}

# ec2 instance
variable "az" {
  default = "c"
}
variable "key-pair" {
  default = "Bakery_Key"
}
variable "ami-id" {
  type = map
  default = {
    us-east-1 = "ami-061202d63ee650371"
    us-east-2 = "ami-0a8251430bac13e68"
    us-west-1 = "ami-0fd5c97e74dafd86d"
    us-west-2 = "ami-04c20ec241d42ae4c"
}
variable "ec2-ins-type" {
  default = "t2.micro"
}
variable "ec2-ins-tag-name" {
  default = "ubuntu"
}

# OS ebs device
variable "ec2-ins-vol-dev-name" {
  default = "/dev/sda1"
}
variable "ec2-ins-vol-type" {
  default = "gp2"
}
variable "ec2-ins-vol-size" {
  default = 8
}
variable "ec2-ins-vol-del-bool" {
  default = true
}

# connection
variable "connection-type" {
  default = "ssh"
}
variable "connection-user" {
  default = "ubuntu"
}
variable "connection-host" {
  default = self.public_ip
}

# scripts files
variable "mount-s3-sh-path-source" {
  default = "shahar's-PRs/bakery-project/mount-sripts/mount_s3_bucket.sh"
}
variable "mount-s3-sh-path-dest" {
  default = "/tmp/mount_s3_bucket.sh"
}
variable "mount-ebs-sh-path-source" {
  default = "shahar's-PRs/bakery-project/mount-sripts/mount_ebs_vol.sh"
}
variable "mount-ebs-sh-path-dest" {
  default = "/tmp/mount_ebs_vol.sh"
}

# ebs vol
variable "ebs-vol-size" {
  default = 1
}
variable "ebs-att-dev-name" {
  default = "/dev/xvdh"
}
variable "data_folder_path" {
  default = "data"
}

# s3 bucket
variable "s3-bucket-name" {
  default = "bakery-bucket-2"
}
variable "s3-bucket-acl" {
  default = "private"
}
variable "s3-bucket-tag-name" {
  default = "bakery-bucket-2"
}
variable "s3-bucket-tag-env" {
  default = "Bakery"
}
variable "s3-bucket-obj-key" {
  default = "my_file"
}
variable "s3-bucket-obj-acl" {
  default = "private"
}
variable "s3-bucket-obj-path" {
  default = "shahar's-PRs/bakery-project/s3-materials/some-txt-file.txt"
}
variable "s3_folder_path" {
  default = "bucket"
}

# security group
variable "sg-name" {
  default = "ubuntu-security-group"
}
variable "sg-tag-name" {
  default = "terraform-sg"
}
