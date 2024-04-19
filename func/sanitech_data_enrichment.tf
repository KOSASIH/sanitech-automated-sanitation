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
  },
  {
    "name": "location",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
  }

  access {
    role = "READER"
    user = "serviceAccount:example-service-account@example-project.iam.gserviceaccount.com"
  }
}

resource "google_bigquery_job" "example" {
  job_id = "example-job"

  configuration {
    query {
      query = "SELECT user_id, event_name, timestamp, geography.continent FROM \`example_project.example_dataset.example_table\`"

      destination_table {
        project_id = "example_project"
        dataset_id = "example_dataset"
        table_id = "enriched_example_table"
      }

      use_legacy_sql = false
    }
  }
}
