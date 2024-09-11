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
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["10.0.0.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-0182f373e66f89c85"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    security_groups = [aws_security_group.my_security_group.id]
  }

  tags = {
    Name = "My EC2 Instance"
  }
}