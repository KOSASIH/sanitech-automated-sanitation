resource "google_bigquery_dataset" "example" {
  dataset_id = "example_dataset"
  project    = "example_project"
  location    = "US"

  table {
    name = "example_table"

    schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "event_name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  }
]
EOF
  }
}
