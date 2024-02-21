data "aws_availability_zones" "main" {
  state = "available"
}

data "aws_ssm_parameter" "instance_ami"{
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}