# 1. Fetch the latest Ubuntu 20.04 AMI ID
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # This is the official ID for Canonical (the makers of Ubuntu)
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

# 3. Fetch the region you are currently working in
data "aws_region" "current" {}

locals {
  # We combine our project name and environment into one "Common" set of tags
  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
    Owner     = "Martina"
  }
}
resource "aws_vpc" "karatu_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}
resource "aws_subnet" "karatu_subnet" {
  vpc_id            = aws_vpc.karatu_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-subnet"
  })
}
resource "aws_internet_gateway" "karatu_igw" {
  vpc_id = aws_vpc.karatu_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}
resource "aws_route_table" "karatu_public_rt" {
  vpc_id = aws_vpc.karatu_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # This means 'All Internet Traffic'
    gateway_id = aws_internet_gateway.karatu_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}
resource "aws_route_table_association" "karatu_public_assoc" {
  subnet_id      = aws_subnet.karatu_subnet.id
  route_table_id = aws_route_table.karatu_public_rt.id
}
resource "aws_security_group" "karatu_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.karatu_vpc.id

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # HTTP Access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "karatu_server" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.karatu_subnet.id
  vpc_security_group_ids      = [aws_security_group.karatu_sg.id]
  associate_public_ip_address = true 

  user_data = <<-EOF
              #!/bin/bash
              sleep 30
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Welcome to Martina's Server!</h1>" > /var/www/html/index.html
              EOF

tags = merge(local.common_tags, {
    Name = "${var.project_name}-server"
  })
}
