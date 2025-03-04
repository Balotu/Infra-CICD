provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "CICD_sg" {
  name        = "CICD_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

resource "aws_instance" "example" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.CICD_sg.id]
  subnet_id     =  "subnet-06b62cc4b80051036"
  key_name      = "My_Demo_KP"
  user_data = <<-EOF
              #!/bin/bash
              # Update the package repository
              yum update -y

              # Install Python
              yum install -y python3

              # Install PostgreSQL
              amazon-linux-extras install postgresql13 -y
              yum install -y postgresql

              # Install Poetry
              curl -sSL https://install.python-poetry.org | python3 -

              # Install Node.js and npm
              curl -o- https://fnm.vercel.app/install | bash
              fnm install 14
              EOF

  tags = {
    Name = "MyEC2Instance"
  }
}

output "instance_id" {
  value = aws_instance.example.id
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

terraform {
  backend "s3" {
    bucket = "my-1st-s3-bucketaham"
    key = "./terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
