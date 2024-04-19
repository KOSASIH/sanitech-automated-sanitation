resource "google_bigquery_dataset_expiration_policy" "example" {
  dataset_id = "example_dataset"
  project    = "example_project"

  expiration_time {
    units = 30
    unit_type = "DAYS"
  }
}

resource "google_bigquery_table_expiration_policy" "example" {
  table_id = "example_table"
  dataset_id = "example_dataset"
  project    = "example_project"

  expiration_time {
    units = 7
    unit_type = "DAYS"
  }
}
