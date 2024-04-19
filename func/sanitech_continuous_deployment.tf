resource "github_actions_workflow" "cd" {
  name = "Continuous Deployment"

  on = {
    push = {
      branches = ["main"]
    }
  }

  jobs = {
    "build" = {
      runs-on = "ubuntu-latest"

      steps = [
        {
          uses = "actions/checkout@v2"
        },
        {
          uses = "actions/setup-go@v2"
          with = {
            go-version = "1.16"
          }
        },
        {
          run = "go build"
        },
        {
          uses = "actions/upload-artifact@v2"
          with = {
            name = "binary",
            path = "./sanitech"
          }
        },
        {
          uses = "marketplace/github-actions-formula/actions/setup-formula@v1"
        },
        {
          uses = "marketplace/github-actions-formula/actions/formula-install@v1"
          with = {
            formula = "kubernetes-helm"
          }
        },
        {
          uses = "marketplace/github-actions-formula/actions/formula-helmfile@v1"
          with = {
            values = "./helmfile.yaml"
          }
        }
      ]
    }
  }
}
