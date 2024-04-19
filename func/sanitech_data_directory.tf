provider "databricks" {
  alias = "example"
  host = "https://example.databricks.com"
  token = "example_token"
}

resource "databricks_table_catalog" "example" {
  provider = databricks.example
  name = "example_catalog"
  description = "Example catalog in Databricks"

  tables {
    name = "example_table"
    description = "Example table in Databricks"
    database_name = "example_database"
  }
}
