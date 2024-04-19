data "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "example" {
  name    = "test.example.com"
  type    = "A"
  zone_id = data.aws_route53_zone.example.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_instance.infrastructure_testing.private_ip
    zone_id                = aws_instance.infrastructure_testing.availability_zone_id
  }
}

resource "aws_instance" "infrastructure_testing" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  tags = {
    Name = "infrastructure-testing"
  }
}

resource "null_resource" "infrastructure_testing" {
  provisioner "remote-exec" {
    inline = [
      "curl -I http://test.example.com"
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      host     = aws_instance.infrastructure_testing.private_ip
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
