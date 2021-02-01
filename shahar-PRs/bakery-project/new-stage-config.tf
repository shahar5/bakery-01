terraform {
  required_version = "<= 0.12.29"
}

provider "aws" {
  profile = var.aws-profile
  region  = var.region
}

#provider "aws" {
#  alias = "virginia"
#  region  = "us-east-1"
#}

resource "aws_vpc" "Bakery_VPC" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "Bakery_VPC"
  }
}

resource "aws_subnet" "Bakery_SUB" {
  vpc_id     = aws_vpc.Bakery_VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Bakery_SUB"
  }
}

resource "aws_internet_gateway" "Bakery_GW" {
  vpc_id = aws_vpc.Bakery_VPC.id

  tags = {
    Name = "Bakery_GW"
  }
}

resource "aws_route_table" "Bakery_RT" {
  vpc_id = aws_vpc.Bakery_VPC.id
  tags = {
    Name        = "Bakery_RT"
  }
}

resource "aws_route" "Bakery_Route" {
  route_table_id         = aws_route_table.Bakery_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Bakery_GW.id
}

resource "aws_route_table_association" "Bakery_rt_asso" {
  subnet_id      = aws_subnet.Bakery_SUB.id
  route_table_id = aws_route_table.Bakery_RT.id
}

resource "aws_security_group" "ubuntu-sg" {
  name        = var.sg-name
  vpc_id      = aws_vpc.Bakery_VPC.id
  depends_on  = [aws_vpc.Bakery_VPC]

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name = var.sg-tag-name
  }
}

resource "aws_instance" "ubuntu" {
  key_name      = var.key-pair
  ami           = var.ami-id[var.region]
  instance_type = var.ec2-ins-type
  availability_zone = "${var.region}${var.az}"
  subnet_id     = aws_subnet.Bakery_SUB.id
  associate_public_ip_address = true

  tags = {
    Name = var.ec2-ins-tag-name
  }

  vpc_security_group_ids = [
    aws_security_group.ubuntu-sg.id
  ]

  ebs_block_device {
    device_name = var.ec2-ins-vol-dev-name
    volume_type = var.ec2-ins-vol-type
    volume_size = var.ec2-ins-vol-size
    delete_on_termination = var.ec2-ins-vol-del-bool
  }

#  lifecycle {
#   ignore_changes = [ebs_block_device]
 #}
  connection {
    type        = var.connection-type
    user        = var.connection-user
    private_key = file(var.connection-key)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = var.mount-s3-sh-path-source
    destination = var.mount-s3-sh-path-dest
  }

  provisioner "file" {
    source      = var.mount-ebs-sh-path-source
    destination = var.mount-ebs-sh-path-dest
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.mount-s3-sh-path-dest}",
      "chmod +x ${var.mount-ebs-sh-path-dest}"
    ]
  }
} ## end of resource

resource "aws_ebs_volume" "ebs_bakery_vol" {
  availability_zone = "${var.region}${var.az}"
  size              = var.ebs-vol-size
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = var.ebs-att-dev-name
  volume_id   = aws_ebs_volume.ebs_bakery_vol.id
  instance_id = aws_instance.ubuntu.id
}

resource "aws_s3_bucket" "bakery-bucket-2" {
  region = var.s3-bucket-region
  bucket = var.s3-bucket-name
  acl    = var.s3-bucket-acl

  tags = {
    Name        = var.s3-bucket-tag-name
    Environment = var.s3-bucket-tag-env
  }
}

# Upload an object
resource "aws_s3_bucket_object" "s3_file" {
  bucket = var.s3-bucket-name
  key    = var.s3-bucket-obj-key
  acl    = var.s3-bucket-obj-acl
  source = var.s3-bucket-obj-path
  etag = filemd5(var.s3-bucket-obj-path)

  depends_on = [
    aws_s3_bucket.bakery-bucket-2,
  ]
}

resource "null_resource" "mount-vols" {

  depends_on = [
    aws_s3_bucket.bakery-bucket-2,
    aws_volume_attachment.ebs_attach
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    type        = var.connection-type
    user        = var.connection-user
    private_key = file(var.connection-key)
    host        = aws_instance.ubuntu.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "${var.mount-s3-sh-path-dest} ${var.AWS_CREDS} ${var.s3_folder_path}",
      "${var.mount-ebs-sh-path-dest} ${var.data_folder_path}"
    ]
  }
}
