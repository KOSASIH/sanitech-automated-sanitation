provider "kubernetes" {
  host = "https://example.kubernetes.com"
  token = "example_token"
}

resource "kubernetes_service" "data_mesh" {
  metadata {
    name = "data-mesh"
  }

  spec {
    selector = {
      app = "data-mesh"
    }

    port {
      name = "grpc"
      port = 9000
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_deployment" "data_mesh" {
  metadata {
    name = "data-mesh"
    labels = {
      app = "data-mesh"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "data-mesh"
      }
    }

    template {
      metadata {
        labels = {
          app = "data-mesh"
        }
      }

      spec {
        container {
          name = "data-mesh"
          image = "example/data-mesh:latest"
          port {
            container_port = 9000
          }

          env {
            name = "GRPC_PORT"
            value = "9000"
          }
        }
      }
    }
  }
}
