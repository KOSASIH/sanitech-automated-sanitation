output "deployment_testing_public_ip" {
  value = aws_instance.deployment_testing.public_ip
}

output "infrastructure_testing_private_ip" {
  value = aws_instance.infrastructure_testing.private_ip
}

output "github_repository_url" {
  value = github_repository.example.html_url
}
