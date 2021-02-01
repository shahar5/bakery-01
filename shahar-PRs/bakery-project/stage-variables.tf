# terraform
variable "tf-version" {
  default = "<= 0.12.29"
}

# aws
variable "region" {
  default = "us-east-1"
}
variable "az" {
  default = "f"
}
variable "aws-profile" {
  default = "default"
}
variable "AWS_CREDS" {}
# ec2 instance
variable "key-pair" {
  default = "Bakery_Project"
}
variable "ami-id" {
  type = map
  default = {
    "us-east-1" = "ami-00ddb0e5626798373"
    "us-east-2" = "ami-0dd9f0e7df0f0a138"
    "us-west-1" = "ami-0a741b782c2c8632d"
    "us-west-2" = "ami-0ac73f33a1888c64a"
  }
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
variable "connection-key" {
  default = "/tmp/source/bakery-01/shahar-PRs/bakery-project/Bakery_Project"
}

# scripts files
variable "mount-s3-sh-path-source" {
  default = "/tmp/source/bakery-01/shahar-PRs/bakery-project/mount-sripts/stage-mount_s3_bucket.sh"
}
variable "mount-s3-sh-path-dest" {
  default = "/tmp/mount_s3_bucket.sh"
}
variable "mount-ebs-sh-path-source" {
  default = "/tmp/source/bakery-01/shahar-PRs/bakery-project/mount-sripts/stage-mount_ebs_vol.sh"
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
variable "s3-bucket-region" {
  default = "us-east-1"
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
  default = "/tmp/source/bakery-01/shahar-PRs/bakery-project/s3-materials/some_txt_file.txt"
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
variable "ingress_rules" {
  type = map
  default = {
    "SSH_rule" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH"
    },
    "HTTPS_rule" = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  }
}
variable "egress_rules" {
  type = map
  default = {
    "allow_all_rule" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow_all"
    }
  }
}
