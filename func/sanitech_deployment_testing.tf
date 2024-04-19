resource "aws_instance" "deployment_testing" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              EOF

  tags = {
    Name = "deployment-testing"
  }
}

resource "null_resource" "deployment_testing" {
  provisioner "remote-exec" {
    inline = [
      "curl -I http://${aws_instance.deployment_testing.public_ip}"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = aws_instance.deployment_testing.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
