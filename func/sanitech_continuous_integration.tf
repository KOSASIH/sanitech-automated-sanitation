provider "github" {
  token = var.github_token
}

resource "github_repository" "example" {
  name        = "example-repo"
  description = "Example repository"
  auto_init   = true
}

resource "github_branch" "example" {
  repository = github_repository.example.name
  branch     = "main"
}

resource "github_branch_protection" "example" {
  repository_id = github_repository.example.node_id
  pattern       = github_branch.example.branch

  required_status_checks {
    strict   = true
    contexts = [github_actions_workflow.example.name]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = true
    require_code_owner_reviews = true
  }
}

resource "github_actions_workflow" "example" {
  name       = "example-workflow"
  repository = github_repository.example.name

  on = {
    push = {
      branches = [github_branch.example.branch]
    }
  }

  jobs = {
    example = {
      runs_on = "ubuntu-latest"

      steps = [
        {
          name  = "Checkout repository"
          uses  = "actions/checkout@v2"
        },
        {
          name  = "Run terraform validate"
          run   = "terraform validate"
        },
        {
          name  = "Run terraform plan"
          run   = "terraform plan -out=tfplan"
        },
        {
          name  = "Apply terraform changes"
          run   = "terraform apply -auto-approve"
        }
      ]
    }
  }
}
