resource "aws_security_group" "my_sg" {
  name        = "my-sg"
  description = "Security group allowing only my IP inbound, all outbound"
  vpc_id     = aws_vpc.my-vpc.id

  ingress {
    description = "my-ip"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["49.205.204.22/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "my-sg"
  }
}