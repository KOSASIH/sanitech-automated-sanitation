resource "aws_instance" "monitoring_testing" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  tags = {
    Name = "monitoring-testing"
  }
}

resource "null_resource" "monitoring_testing" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y collectd",
      "sudo service collectd start"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = aws_instance.monitoring_testing.public_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "local-exec" {
    command = "curl -o /dev/null http://${aws_instance.monitoring_testing.public_ip}:25826/collectd"
  }}
