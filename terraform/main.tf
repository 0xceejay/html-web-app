terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.53.1"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Configure the GCP provider
provider "google" {
  project = "workspace"
  region = "us-central1"
}

# Variables
variable "ssh_key" {}
variable "my-ip" {}


# Configure default security group
resource "aws_security_group" "new_sg" {

  # Allow inbound HTTP access to the web servers from any IPv4 address.
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH access from your network over IPv4.
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [var.my-ip]
  }
  # Allow outbound traffic to any IP address
  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "my-security-group"
  }
}

# Create ec2 instance on subnet
resource "aws_instance" "my_ec2_instance" {
  # Amazon linux 2 AMI
  ami = "ami-0dfcb1ef8550277af"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.new_sg.id]
  key_name = var.ssh_key

  tags = {
    "Name" = "my_ec2"
  }
}

# Create elastic ip for the instance
resource "aws_eip" "elastic_ip" {
  instance = aws_instance.my_ec2_instance.id
  vpc = true
}

output "instance_details" {
  value = {
    public_ip = aws_instance.my_ec2_instance.public_ip
    elastic_ip = aws_eip.elastic_ip.public_ip
  }
}
