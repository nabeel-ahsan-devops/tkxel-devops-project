resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.example.id]
}
resource "aws_instance" "example" {
  # ... other configuration
  user_data = <<EOF
    #!/bin/bash
    exec ansible-playbook -i "{{ lookup 'file' '/etc/ansible/hosts' }}" ansible/ec2_setup.yml
    EOF
}