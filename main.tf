provider "aws" {
  region = "us-east-1" # Define the AWS region
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = aws_vpc.example.id # Associate with the VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with opening access to 0.0.0.0/0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "example" {
  instance_type = "t2.micro"  # Adjust the instance type as needed
  ami           = "ami-0182f373e66f89c85"  # Replace with the desired AMI ID

  network_interface {
    subnet_id     = "subnet-062e27b70b10066f2"  # Replace with your subnet ID
    security_groups = ["sg-05c8be0053e37e7db"]  # Replace with your security group ID
  }

  tags = {
    Name = "My EC2 Instance"
  }
}