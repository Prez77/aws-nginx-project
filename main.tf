# main.tf

# ---------------------------------------------------
# VPC (Virtual Private Cloud)
# ---------------------------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "nginx-project-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a" # Use AZ 'a' in your chosen region
  map_public_ip_on_launch = true # Automatically assign public IP to instances
  tags = {
    Name = "nginx-project-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "nginx-project-igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Allow all outbound traffic
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "nginx-project-public-rt"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------------------------------
# Security Group for Nginx
# ---------------------------------------------------
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-web-sg"
  description = "Allow HTTP inbound traffic and all outbound"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPs (be cautious in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow to all IPs
  }

  tags = {
    Name = "nginx-project-sg"
  }
}

# ---------------------------------------------------
# EC2 Instance for Nginx
# ---------------------------------------------------
resource "aws_instance" "nginx_web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true # Ensure it gets a public IP

  # User data to install Nginx on instance launch
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Hello from Terraform Nginx Web Server!</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "nginx-terraform-server"
  }
}
