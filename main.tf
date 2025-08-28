terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
       version = "6.10.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"
  description = "Allow SSH and HTTP"
  

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]

  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]

  }
}
resource "aws_instance" "my_ec2" {
  ami = "ami-0861f4e788f5069dd"
  count = 2
  instance_type = "t2.micro"
  key_name ="DemoKeyPair" 
  security_groups = [aws_security_group.ec2_sg.name]
  tags = {
    Name ="MyTerraformEc2"
  }

}

output "ec2_public_ip" {
  value = aws_instance.my_ec2[*].public_ip
}