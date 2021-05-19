data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "pubkey" {
  key_name   = "public-key-tf"
  public_key = var.pub_key
}

resource "aws_security_group" "ssh-sg" {
  vpc_id = aws_vpc.main.id
  name   = "ssh-tf-sg"

  ingress {
    description = "SSH connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows pinging the instance
  # https://github.com/hashicorp/terraform/issues/1313#issuecomment-107619807
  ingress {
    description = "ICMP - ping"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allowing SSH and ICMP"
  }
}

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.pubkey.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]

  tags = {
    Name = "SI instance"
  }
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.vm.id
  vpc      = true

  tags = {
    Name = "SI public IP"
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.vm.public_ip
}
