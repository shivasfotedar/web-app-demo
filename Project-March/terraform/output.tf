output "aws_instance_blue_public_ip" {
  value = aws_instance.demo_blue_instance.public_ip
}

output "aws_instance_green_public_ip" {
  value = aws_instance.demo_green_instance.public_ip
}

output "subnet_ids" {
  value = data.aws_subnets.private_subnets.ids
}