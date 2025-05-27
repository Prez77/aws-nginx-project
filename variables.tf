# variables.tf
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1" # Bangalore region (Mumbai is ap-south-1)
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "ami_id" {
  description = "The AMI ID for Ubuntu Server 22.04 LTS (HVM), SSD Volume Type"
  type        = string
  # IMPORTANT: Replace this with the latest AMI ID for your chosen region and OS.
  # You can find it in the EC2 console or by using a data source.
  # Example for ap-south-1 Ubuntu 22.04 LTS HVM:
  default = "ami-0fc5ee7b40d04c40b" # As of May 2025 (verify latest for your region)
}

variable "server_port" {
  description = "The port for the web server"
  type        = number
  default     = 80
}
