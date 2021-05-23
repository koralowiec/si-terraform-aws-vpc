resource "aws_db_subnet_group" "private_db_subnets" {
  name       = "private_database_subnets"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "private_database_subnets"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "database_security_group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "postgresql_instance_sg"
  }
}

resource "aws_db_instance" "postgresql_instance" {
  instance_class = "db.t3.micro"
  engine         = "postgres"
  engine_version = "13.1"
  username       = "arek"
  password       = var.db_password
  allocated_storage      = 5

  db_subnet_group_name = aws_db_subnet_group.private_db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az = true

  skip_final_snapshot = true
}

output "db_hostname" {
  description = "Database instance hostname"
  value = aws_db_instance.postgresql_instance.address
  sensitive = true
}
