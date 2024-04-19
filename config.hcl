provider "aws" {
  region = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_instance" "sanitech-instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = "sanitech-instance"
  }
}
