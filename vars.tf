variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS's region name"
}

variable "az_first" {
  type        = string
  default     = "us-east-1a"
  description = "First availability zone (for the public and one of private subnets)"
}

variable "az_second" {
  type        = string
  default     = "us-east-1b"
  description = "Second availability zone (for one of private subnets)"
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
  default     = "10.0.0.0/24"
  description = "CIDR block for public subnet (in the VPC)"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for the first private subnet (in the VPC)"
}

variable "private_subnet_cidr_second" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for the second private subnet (in the VPC)"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of EC2 that will be created"
}

variable "db_password" {
  type        = string
  description = "Password to the Postgresql instance"
}

