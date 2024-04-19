resource "aws_instance" "performance_testing" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  tags = {
    Name = "performance-testing"
  }
}

resource "null_resource" "performance_testing" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "siege -c100 -t30S http://${aws_instance.performance_testing.public_ip}"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = aws_instance.performance_testing.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
