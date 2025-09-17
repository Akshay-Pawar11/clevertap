resource "aws_launch_template" "my_wp_lt" {
  name_prefix   = "wp-lt-"
  image_id      = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "main"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.wp_sg_ec2.id]
    subnet_id                   = aws_subnet.private-subnet-1a.id
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
    db_host     = var.db_host
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wp-instance"
    }
  }
}

resource "aws_autoscaling_group" "wp_asg" {
  name                = "wp-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.private-subnet-1a.id]

  launch_template {
    id      = aws_launch_template.my_wp_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.my-wp-tg.arn]

  tag {
    key                 = "Name"
    value               = "wp-asg-instance"
    propagate_at_launch = true
  }
}