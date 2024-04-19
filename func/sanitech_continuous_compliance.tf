resource "ansible_galaxy" "requirements" {
  project_dir = "."
  requirements = "requirements.yml"
}

resource "ansible_playbook" "compliance" {
  project_dir = "."
  playbook = "playbook.yml"
  extra_arguments = [
    "--extra-vars",
    "ansible_user=ec2-user",
    "--private-key=${var.private_key}",
    "--limit=${var.bastion_ip}",
  ]

  environment = {
    AWS_ACCESS_KEY_ID = aws_iam_access_key.example.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.example.secret
  }
}
