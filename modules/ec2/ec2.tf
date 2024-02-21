# AMI
# Size/Instance Type
# VPC/Subnet
# Security Group
# Key Pairs
# Tags
# User Data

# Local variable
locals {
    instance_size = "t3.micro"
    key_pair = "jverdecia-key"

    common_tags = {
        Name = "jv-EC2"
        name = "justin"
    }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bjgomes-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "main" {
    ami = var.instance_ami
    instance_type = local.instance_size
    key_name = local.key_pair
    subnet_id = var.subnet_id
    security_groups = [aws_security_group.allow_ssh.id]

    tags = local.common_tags
}

resource "aws_instance" "secondary" {
    ami = var.instance_ami
    instance_type = local.instance_size
    key_name = local.key_pair
    subnet_id = var.subnet_id
    security_groups = [aws_security_group.allow_ssh.id]

    tags = local.common_tags
}