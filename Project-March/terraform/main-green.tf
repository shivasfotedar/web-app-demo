# attach elastic ip : 23.21.133.22
resource "aws_security_group" "demo_green_security" {
  name        = var.demo_green_security_name
  description = "Allow ports for java app demo"
  vpc_id      = module.vpc.vpc_id

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

resource "aws_instance" "demo_green_instance" {
  ami           = "ami-09ba48996007c8b50"
  instance_type = var.S
  key_name      = var.demo_key_name
  subnet_id              = data.aws_subnets.private_subnets.ids[1]
  #iam_instance_profile = aws_iam_instance_profile.demo-profile.name
  root_block_device {
    volume_size = 10
  }
  user_data              = file(var.shell_file_green)
  vpc_security_group_ids = [aws_security_group.demo_green_security.id]
  tags = {
    Name = var.demo_green_instance_name,
    Environment = "Dev",
    Project = "pa"
  }
}

# resource "aws_iam_role" "demo-role" {
#   name = "ec2_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = "RoleForEC2"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "demo-attach" {
#   name       = "demo1-attachment"
#   roles      = [aws_iam_role.demo-role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_instance_profile" "demo-profile" {
#   name = "demo_profile"
#   role = aws_iam_role.demo-role.name
# }