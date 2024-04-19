resource "aws_security_group" "security_testing" {
  name        = "security-testing"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "security_testing" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.security_testing.id]

  tags = {
    Name = "security-testing"
  }
}

resource "null_resource" "security_testing" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nikto",
      "nikto -h http://${aws_instance.security_testing.public_ip}"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = aws_instance.security_testing.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
