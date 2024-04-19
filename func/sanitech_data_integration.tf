resource "google_dataflow_job" "example" {
  name              = "example-dataflow-job"
  template_gcs_path = "gs://dataflow-templates/latest/WordCount"
  parameters = {
    inputFile = "gs://dataflow-samples/shakespeare/kinglear.txt"
    outputFile = "gs://${google_storage_bucket.example.name}/output/wordcount"
  }

  machine_type = "n1-standard-1"
  num_workers = 2

  on_delete = "cancel"

  lifecycle {
    ignore_changes = [parameters]
  }
}

resource "google_storage_bucket" "example" {
  name = "example-bucket"
}
