provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_instance" "my_instance" {
    ami = "data.aws_ami.ubuntu.id"
    instance_type = "t2.micro"
    tags = {
      "Name" = "myEC2"
    }
 
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}  
  

