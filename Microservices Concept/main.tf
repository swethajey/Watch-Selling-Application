provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
}

# Create Security Group
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instances for each service
resource "aws_instance" "product_service" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with appropriate AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "product-service"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 5000:5000 product_service_image
              EOF
}

resource "aws_instance" "order_service" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "order-service"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 5001:5001 order_service_image
              EOF
}

resource "aws_instance" "user_service" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "user-service"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 5002:5002 user_service_image
              EOF
}
