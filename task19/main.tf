provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "web_app_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_app_subnet" {
  vpc_id     = aws_vpc.web_app_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "web_app_gateway" {
  vpc_id = aws_vpc.web_app_vpc.id
}

resource "aws_route_table" "web_app_route_table" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_app_gateway.id
  }
}

resource "aws_route_table_association" "web_app_route_table_association" {
  subnet_id      = aws_subnet.web_app_subnet.id
  route_table_id = aws_route_table.web_app_route_table.id
}

resource "aws_security_group" "web_app_security_group" {
  vpc_id = aws_vpc.web_app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 
    
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
    

resource "aws_instance" "my_instance" {
  ami           = "ami-0c9c942bd7bf113a2"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.web_app_security_group.id]
  subnet_id              = aws_subnet.web_app_subnet.id

  tags = {
    "Name" = "myEC2"
  }
}
