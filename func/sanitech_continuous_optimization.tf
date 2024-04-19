resource "google_container_cluster" "primary" {
  name               = "primary"
  location           = "us-central1-a"
  initial_node_count = 3

  node_config {
    preemptible  = true
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  auto_repair = true
  auto_upgrade = true

  lifecycle {
    ignore_changes = [node_config]
  }
}
