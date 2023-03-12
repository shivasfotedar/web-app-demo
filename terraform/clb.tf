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
  Environment = var.environment,
  Tier = "public"
  }
}

resource "aws_elb" "bar" {
  name               = var.elb_name
  subnets            = toset(data.aws_subnets.sub_selected.ids)
  security_groups = [aws_security_group.demo_blue_security.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [aws_instance.demo_blue_instance.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "demo-elb"
  }
}