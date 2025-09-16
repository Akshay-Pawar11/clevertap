#Creating VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.vpc_name}"
  }
}

#Creating Subnets
resource "aws_subnet" "public-subnet-1a" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.public-subnet-1a-cidr
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "public-subnet-1a"
  }
}
resource "aws_subnet" "public-subnet-2b" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.public-subnet-2b-cidr
  availability_zone = "ap-south-1b"
  tags = {
    "Name" = "public-subnet-2b"
  }
}
resource "aws_subnet" "private-subnet-1a" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.private-subnet-1a-cidr
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "private-subnet-1a"
  }
}
resource "aws_subnet" "private-subnet-2b" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.private-subnet-2b-cidr
  availability_zone = "ap-south-1b"
  tags = {
    "Name" = "private-subnet-2b"
  }
}

#Creating IG
resource "aws_internet_gateway" "my-ig" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "${var.ig_name}"
  }
}

#Creating ElasticIP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

#Creating Natgateway
resource "aws_nat_gateway" "my-nat-gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1a.id
  tags = {
    "Name" = "${var.natgateway_name}"
  }
}

#Creating RouteTables
resource "aws_route_table" "my-route-table-public" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ig.id
  }
  tags = {
    "Name" = "my-route-table-public"
  }
}

resource "aws_route_table" "my-route-table-private" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
  }
  tags = {
    "Name" = "my-route-table-private"
  }
}

#Subnet Association with Route Table
resource "aws_route_table_association" "public-subnet-1a" {
    subnet_id = aws_subnet.public-subnet-1a.id
    route_table_id = aws_route_table.my-route-table-public.id
}

resource "aws_route_table_association" "public-subnet-2b" {
    subnet_id = aws_subnet.public-subnet-2b.id
    route_table_id = aws_route_table.my-route-table-public.id
}

resource "aws_route_table_association" "private-subnet-1a" {
    subnet_id = aws_subnet.private-subnet-1a.id
    route_table_id = aws_route_table.my-route-table-private.id
}

resource "aws_route_table_association" "private-subnet-2b" {
    subnet_id = aws_subnet.private-subnet-2b.id
    route_table_id = aws_route_table.my-route-table-private.id
}
