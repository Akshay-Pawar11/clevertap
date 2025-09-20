resource "aws_db_subnet_group" "default" {
  name       = "wordpress-rds-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1a.id, aws_subnet.private-subnet-2b.id]
}

resource "aws_db_instance" "wordpress" {
  identifier             = "wordpress-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_root_username
  password               = var.db_root_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  storage_type           = "gp2"
}