variable "aws_region" { 
    type = string, 
    default = "ap-south-1" 
}
variable "key_name" { 
    type = string, 
    description = "aws-demo-ec2" 
}
variable "public_key_path" {
    type = string, 
    description = "Path to public key file (id_rsa.pub)" 
}
variable "vpc_id" { 
    type = string, 
    description = "VPC ID to deploy instances into" 
}
variable "subnet_id" { 
    type = string, 
    description = "public_subnet_cidr" 
}

variable "my_ip_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ubuntu_ami" {
  type        = string
  description = "ami-02b8269d5e85954ef"
}

variable "centos_ami" {
  type        = string
  description = "ami-01ca13db604661046"
}

variable "windows_ami" {
  type        = string
  description = "ami-0ae0093476c7a1da6"
}
