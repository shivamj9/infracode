terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# The AWS provider automatically reads settings from your ~/.aws/credentials file
provider "aws" {
  region = "us-east-1" 
}

# A simple AWS test resource
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "TerraformTestVPC"
  }
}

# 2. Dynamic lookup for the latest Ubuntu 22.04 Free-Tier AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Official Canonical/Ubuntu AWS Account ID
}

# 3. Define the EC2 Instance Resource
resource "aws_instance" "my_first_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Free-tier eligible size

  tags = {
    Name        = "Terraform-EC2-Demo"
    Environment = "Dev"
  }
}

# 4. Output the public IP once the instance is created
output "instance_public_ip" {
  description = "The public IP address of the newly created EC2 instance"
  value       = aws_instance.my_first_server.public_ip
}