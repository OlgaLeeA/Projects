provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"
  
  tags = {
    Name = "myEC2"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}


