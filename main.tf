provider "aws" {
  region  = "us-west-1" # Change to your desired AWS region
  profile = "my-profile"
}

resource "aws_security_group" "instance-sg" {
  name        = "instance-security-group"
  description = "Example security group for EC2 instance"
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance-sg.id
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance-sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance-sg.id
}

resource "aws_instance" "example" {
  ami             = "ami-0f8e81a3da6e2510a" # Amazon Linux 2 AMI in us-west-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance-sg.name]
  key_name        = "ayoterraformkey" # Change this to your key pair name

  user_data = <<-EOF
  #!/bin/bash
  yum -y update
  amazon-linux-extras install nginx1.12
  service nginx start
  chkconfig nginx on
  EOF

  tags = {
    Name = "Example-instance"
  }
}
