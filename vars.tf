variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS's region name"
}

variable "pub_key" {
  type        = string
  description = "Public key that will be placed at authorized_keys at ec2 instance"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for public subnet (in the VPC)"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "CIDR block for private subnet (in the VPC)"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of EC2 that will be created"
}
