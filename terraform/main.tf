terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


resource "aws_security_group" "ssh_http" {
  name        = "devops-demo-sg"
  description = "Allow SSH/RDP and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ubuntu instance
resource "aws_instance" "ubuntu" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]
  key_name                    = var.key_name
  tags = { Name = "demo-ubuntu" }
}

# CentOS instance
resource "aws_instance" "centos" {
  ami                         = var.centos_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]
  key_name                    = var.key_name
  tags = { Name = "demo-centos" }
}

# Windows instance
resource "aws_instance" "windows" {
  ami                         = var.windows_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh_http.id]
  key_name                    = var.key_name
  tags = { Name = "demo-windows" }
}

output "ubuntu_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "centos_public_ip" {
  value = aws_instance.centos.public_ip
}

output "windows_public_ip" {
  value = aws_instance.windows.public_ip
}
