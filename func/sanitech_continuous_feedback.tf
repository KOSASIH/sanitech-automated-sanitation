resource "google_scheduler_job" "schedule_feedback_collection" {
  name     = "schedule-feedback-collection"
  region   = "us-central1"
  schedule = "0 0 * * *"

  target_type = "http"

  http_target {
    http_method = "POST"
    uri         = "https://example.com/collect-feedback"
  }

  retry_config {
    retry_count = 3
  }
}
