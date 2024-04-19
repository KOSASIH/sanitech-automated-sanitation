provider "databricks" {
  alias = "example"
  host = "https://example.databricks.com"
  token = "example_token"
}

resource "databricks_marketplace_product" "example" {
  provider = databricks.example
  name = "example_product"
  description = "Example product in Databricks Marketplace"
  summary = "Example summary"
  terms_of_service = "https://example.com/terms"
  version = "1.0.0"
  release_notes = "Initial release"

  tags = {
    "category" = "example_category"
    "topic" = "example_topic"
  }

  databricks_file_paths {
    file_path = "dbfs:/example_path/example_file"
    label = "Example label"
  }

  databricks_file_paths {
    file_path = "dbfs:/example_path/example_license"
    label = "Example label"
  }
}
