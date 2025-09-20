resource "aws_launch_template" "my_be_lt" {
  name_prefix   = "be-lt-"
  image_id      = "ami-01b6d88af12965bb6"
  instance_type = "t2.micro"
  key_name      = "main"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }


  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.be_sg_ec2.id]
    subnet_id                   = aws_subnet.private-subnet-1a.id
  }

  user_data = base64encode(templatefile("${path.module}/be_userdata.sh", {}))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "be-instance"
    }
  }
}

resource "aws_autoscaling_group" "be_asg" {
  name                = "be-asg"
  desired_capacity    = 0
  min_size            = 0
  max_size            = 0
  vpc_zone_identifier = [aws_subnet.private-subnet-1a.id]

  launch_template {
    id      = aws_launch_template.my_be_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.my-be-tg.arn]

  tag {
    key                 = "Name"
    value               = "be-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "be_cpu_scale" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.be_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_autoscaling_policy" "be_request_scale" {
  name                   = "request-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.be_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.my_alb_wp.arn_suffix}/${aws_lb_target_group.my-be-tg.arn_suffix}"
    }
    target_value = 1000.0
  }
}
