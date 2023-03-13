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
  name = var.instance_profile
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


resource "aws_autoscaling_group" "example" {
  name                 = "example-asg"
  #availability_zones   = data.aws_availability_zones.available.names
  launch_configuration = aws_launch_configuration.example.name
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier  = toset(data.aws_subnets.private_subnets.ids)
  load_balancers = ["${aws_elb.bar.name}"]

  tag {
    key                 = "Name"
    value               = "example-instance"
    propagate_at_launch = true
  }

  #vpc_security_group_ids = [aws_security_group.example.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "example" {
  name_prefix = "example-lc"
  image_id    = var.ami_id
  instance_type = var.S
  security_groups = [aws_security_group.demo_blue_security.id]
  user_data       = "${data.template_file.init.rendered}"
  iam_instance_profile = aws_iam_instance_profile.demo-profile.name
  
}


resource "aws_autoscaling_policy" "example-cpu-policy" {
  name = "demo-cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.example.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm" {
  alarm_name = "demo-cpu-alarm"
  alarm_description = "demo-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
  dimensions = {
  "AutoScalingGroupName" = "${aws_autoscaling_group.example.name}"
}
actions_enabled = true
alarm_actions = ["${aws_autoscaling_policy.example-cpu-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "example-cpu-policy-scaledown" {
  name = "demo-cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.example.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaledown" {
  alarm_name = "demo-cpu-alarm-scaledown"
  alarm_description = "demo-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "5"
  dimensions = {
  "AutoScalingGroupName" = "${aws_autoscaling_group.example.name}"
  }
  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.example-cpu-policy-scaledown.arn}"]
}
