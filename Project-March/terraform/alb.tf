data "aws_vpc" "selected" {
   filter {
    name   = "tag:Environment"
    values = [var.environment] 
  }

  depends_on = [
    module.vpc
  ]
}

data "aws_subnets" "sub_selected" {
  tags = {
  Tier = "public"
  }
}


resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [data.aws_subnets.sub_selected.ids[0],data.aws_subnets.sub_selected.ids[1]]

  tags = {
    Environment = "Dev"
  }
}

resource "aws_security_group" "lb" {
  name_prefix = "example-alb"
   vpc_id      = data.aws_vpc.selected.id

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
}

resource "aws_lb_target_group_attachment" "blue_attach" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.demo_blue_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green_attach" {
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = aws_instance.demo_green_instance.id
  port             = 80
}

resource "aws_lb_target_group" "blue" {
  name_prefix = "b-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_lb_target_group" "green" {
  name_prefix = "gs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener_rule" "green" {
  listener_arn = aws_lb_listener.example.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

 condition {
    path_pattern {
      values = ["/green/*"]
    }
  }
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = aws_lb_listener.example.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

condition {
    path_pattern {
      values = ["/blue/*"]
    }
  }
}
