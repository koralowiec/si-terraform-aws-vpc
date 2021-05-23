# Net and subnets definitions

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "SI VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az_first

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_second
  availability_zone = var.az_first

  tags = {
    Name = "Private subnet"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_second
  availability_zone = var.az_second

  tags = {
    Name = "2nd private subnet"
  }
}

# Internet access

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "IGW for public subnet"
  }
}

resource "aws_route_table" "traffic_to_igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.traffic_to_igw.id
}

resource "aws_network_acl" "public_subnet_acl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.public.id]

  # For being able to SSH to the instance
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  # For being able to ping to the instance
  ingress {
    protocol   = "icmp"
    rule_no    = 800
    action     = "allow"
    icmp_type  = -1
    icmp_code  = -1
    from_port  = 0
    to_port    = 8
    cidr_block = "0.0.0.0/0"
  }

  # For being able to wget (http/https) from the instance
  ingress {
    protocol   = "tcp"
    rule_no    = 900
    action     = "allow"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  # For being able to wget (http) from the instance
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  # For being able to wget (https) from the instance
  egress {
    protocol   = "tcp"
    rule_no    = 201
    action     = "allow"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  # For being able to ping from the instance
  egress {
    protocol   = "icmp"
    rule_no    = 800
    action     = "allow"
    icmp_type  = -1
    icmp_code  = -1
    from_port  = 0
    to_port    = 8
    cidr_block = "0.0.0.0/0"
  }

  # For being able to SSH to the instance
  egress {
    protocol   = "tcp"
    rule_no    = 900
    action     = "allow"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "Public subnet's ACL"
  }
}
