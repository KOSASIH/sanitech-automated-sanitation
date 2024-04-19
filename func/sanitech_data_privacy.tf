resource "google_bigquery_dataset" "example" {
  dataset_id = "example_dataset"
  project    = "example_project"
  location    = "US"

  access {
    role = "READER"
    user_by_email = "example_user@example.com"
  }

  access {
    role = "WRITER"
    user_by_email = "example_user@example.com"
  }

  access {
    role = "OWNER"
    user_by_email = "example_user@example.com"
  }
}

resource "google_bigquery_dataset_access" "example" {
  dataset_id = google_bigquery_dataset.example.dataset_id
  project    = google_bigquery_dataset.example.project
  role       = "READER"
  user_by_email = "example_user@example.com"
}
