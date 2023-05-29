provider "aws" {
  region = "ap-northeast-3"
}

resource "aws_instance" "example" {
  ami           = "ami-0997b4797ae01c920"
  key_name      = "my-key"
  instance_type = "t2.micro"
  
  tags = {
    Name = "myEC2"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}


