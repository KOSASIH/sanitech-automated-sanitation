resource "google_sql_database_instance" "example" {
  name = "example-instance"

  backup_configuration {
    point_in_time_recovery_enabled = true
    location                       = "us-central1"
    start_time                     = "00:00"
    transaction_log_retention_days = 7
  }
}
