provider "aws" {
  region = var.region
}

data "aws_elb" "example_lb" {
  name = var.elb_name
  depends_on = [
    aws_elb.bar
  ]
}

output "lb_dns_name" {
  value = data.aws_elb.example_lb.dns_name
}


data "aws_subnets" "private_subnets" {
  tags = {
  Environment = var.environment,
  Tier = "private"
  }
  depends_on = [
    module.vpc
  ]
}

resource "aws_security_group" "demo_blue_security" {
  name        = var.demo_blue_security_name
  description = "Allow ports for java app demo"
  vpc_id      = module.vpc.vpc_id

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "demo_blue_instance" {
  ami           = var.ami_id
  instance_type = var.S
  key_name      = var.demo_key_name
  iam_instance_profile = aws_iam_instance_profile.demo-profile.name
  root_block_device {
    volume_size = 10
  }
  #user_data              = file(var.shell_file_blue)
  user_data               = "${data.template_file.init.rendered}"
  subnet_id              = data.aws_subnets.private_subnets.ids[1]
  vpc_security_group_ids = [aws_security_group.demo_blue_security.id]
  tags = {
    Name = var.demo_blue_instance_name,
    Environment = "Dev",
    Project = "pa"
  }

  depends_on = [
    module.vpc

  ]
}

resource "aws_iam_role" "demo-role" {
  name = var.ec2_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "demo-attach" {
  role      = aws_iam_role.demo-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "demo-profile" {
  name = "demo_profile"
  role = aws_iam_role.demo-role.name
}


data "template_file" "init" {
  template = "${file("${path.module}/automation-blue.sh.tmpl")}"
  vars = {
    artifact_name = var.artifact_name
  }
}

output "user_script" {
  value = "${data.template_file.init.rendered}"
}
