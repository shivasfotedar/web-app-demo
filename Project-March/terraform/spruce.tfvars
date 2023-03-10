region = "ap-south-1"

demo_blue_instance_name = "demo-blue-instance"
demo_green_instance_name = "demo-green-instance"
demo_blue_security_name = "terraform_blue_practice"
demo_green_security_name = "terraform_green_practice"
demo_key_name = "demo-key"
shell_file_blue = "./automation-blue.sh"
shell_file_green = "./automation-green.sh"

XL = ""
L = "m5.xlarge"
M = "t3a.small"
S = "t2.micro"



#####################################################

vpc_name = "demo-vpc"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
cidr_block = "10.0.0.0/16"
environment = "demo"