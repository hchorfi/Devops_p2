terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_instance" "master" {
  ami             = "ami-085284d24fe829cd0"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.sg_master.name]
  count           = 1
  key_name        = var.instance_ssh_key_name

  tags = {
    Name = "master"
  }

  provisioner "local-exec" {
    command = <<EOT
                echo ${self.public_ip} ${self.tags.Name} >> ${var.hosts_file}
                echo ${self.private_ip} ${self.tags.Name} >> ${var.inventory_file}
              EOT
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.instance_ssh_key_path}")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${self.tags.Name}",
      "hostname"
    ]
  }
}

resource "aws_instance" "worker" {
  ami             = "ami-085284d24fe829cd0"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.sg_worker.name]
  count           = 2
  key_name        = var.instance_ssh_key_name

  tags = {
    Name = "worker${count.index + 1}"
  }

  provisioner "local-exec" {
    command = <<EOT
                echo ${self.public_ip} ${self.tags.Name} >> ${var.hosts_file}
                echo ${self.private_ip} ${self.tags.Name} >> ${var.inventory_file}
              EOT
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.instance_ssh_key_path}")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${self.tags.Name}",
      "hostname"
    ]
  }
}

resource "aws_security_group" "sg_master" {
  name        = "sg_master"
  description = "allowed traffic to the cluster master"

  ingress {
    from_port        = 6783
    to_port          = 6783
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 2379
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 10257
    to_port          = 10257
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 10259
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_master"
  }

}

resource "aws_security_group" "sg_worker" {
  name = "sg_worker"
  description = "allowed traffic to the cluster worker"

  ingress {
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 6783
    to_port          = 6783
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_worker"
  }
}
