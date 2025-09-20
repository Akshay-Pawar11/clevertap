#Public ALB
resource "aws_lb" "my_alb_wp" {
  name               = var.alb_name
  load_balancer_type = var.alb_type
  subnets            = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-2b.id]
  security_groups    = [aws_security_group.my_sg.id]

}

#ALB Listners for default 80 port
resource "aws_lb_listener" "my_alb_wp" {
  load_balancer_arn = aws_lb.my_alb_wp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }
}

#ALB Listners for hostheader in 80 port
resource "aws_lb_listener_rule" "host-listner" {
  listener_arn = aws_lb_listener.my_alb_wp.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-wp-tg.arn

  }

  condition {
    host_header {
      values = [aws_lb.my_alb_wp.dns_name]
    }
  }

  tags = {
    "Name" = "wordpress"
  }

}

resource "aws_lb_target_group" "my-wp-tg" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "302"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

#ALB Listners for hostheader in 80 port
resource "aws_lb_listener_rule" "be-host-listner" {
  listener_arn = aws_lb_listener.my_alb_wp.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-be-tg.arn

  }

  condition {
    path_pattern {
      values = ["/login"]
    }
  }

  tags = {
    "Name" = "be"
  }

}

resource "aws_lb_target_group" "my-be-tg" {
  name     = var.be_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}