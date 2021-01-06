terraform {
  required_version = ${tf-version}
}

provider "aws" {
  profile = ${aws-profile}
  region  = ${region}
}

resource "aws_security_group" "ubuntu-sg" {
  name        = ${sg-name}

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# 443 port is for s3fs
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = ${sg-tag-name}
  }
}

resource "aws_instance" "ubuntu" {
  key_name      = ${key-pair}
  ami           = ${ami-id}
  instance_type = ${ec2-ins-type}
  availability_zone = ${region}${az}

  tags = {
    Name = ${ec2-ins-tag-name}
  }

  vpc_security_group_ids = [
    aws_security_group.ubuntu-sg.id
  ]

  ebs_block_device {
    device_name = ${ec2-ins-vol-dev-name}
    volume_type = ${ec2-ins-vol-type}
    volume_size = ${ec2-ins-vol-size}
    delete_on_termination = ${ec2-ins-vol-del-bool}
  }

#  lifecycle {
#   ignore_changes = [ebs_block_device]
 #}
  connection {
    type        = ${connection-type}
    user        = ${connection-user}
    private_key = ${connection-key}
    host        = ${connection-host}
  }

  provisioner "file" {
    source      = ${mount-s3-sh-path-source}
    destination = ${mount-s3-sh-path-dest}
  }

  provisioner "file" {
    source      = ${mount-ebs-sh-path-source}
    destination = ${mount-ebs-sh-path-dest}
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${mount-s3-sh-path-dest}",
      "chmod +x ${mount-ebs-sh-path-dest}"
    ]
  }
} ## end of resource

resource "aws_ebs_volume" "ebs_bakery_vol" {
  availability_zone = ${region}${az}
  size              = ${ebs-vol-size}
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = ${ebs-att-dev-name}
  volume_id   = aws_ebs_volume.ebs_bakery_vol.id
  instance_id = aws_instance.ubuntu.id
}

resource "aws_s3_bucket" "bakery-bucket-2" {
  bucket = ${s3-bucket-name}
  acl    = ${s3-bucket-acl}

  tags = {
    Name        = ${s3-bucket-tag-name}
    Environment = ${s3-bucket-tag-env}
  }
}

# Upload an object
resource "aws_s3_bucket_object" "s3_file" {
  bucket = ${s3-bucket-name}
  key    = ${s3-bucket-obj-key}
  acl    = ${s3-bucket-obj-acl}
  source = ${s3-bucket-obj-path}
  etag = filemd5(${s3-bucket-obj-path})

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
    type        = ${connection-type}
    user        = ${connection-user}
    private_key = ${connection-key}
    host        = aws_instance.ubuntu.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "${mount-s3-sh-path-dest} ${AWS_CREDS} ${s3_folder_path}",
      "${mount-ebs-sh-path-dest} ${data_folder_path}"
    ]
  }
}
