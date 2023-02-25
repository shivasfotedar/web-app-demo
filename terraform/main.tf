# attach elastic ip : 23.21.133.22

provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "demo_security" {
  name        = var.demo_security_name
  description = "Allow ports for java app demo"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8983
    to_port     = 8983
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo_instance" {
  ami           = "ami-02e136e904f3da870"
  instance_type = var.S
  key_name      = var.demo_key_name
  root_block_device {
    volume_size = 10
  }
  #user_data              = file(var.shell_file)
  vpc_security_group_ids = [aws_security_group.demo_security.id]
  tags = {
    Name = var.demo_instance_name
  }
}
