provider "databricks" {
  alias = "example"
  host = "https://example.databricks.com"
  token = "example_token"
}

resource "databricks_table_metadata" "example" {
  provider = databricks.example
  table_name = "example_table"
  description = "Example table in Databricks"
  table_type = "manual"

  columns {
    name = "id"
    description = "Example id column"
    data_type = "integer"
    is_nullable = false
  }

  columns {
    name = "name"
    description = "Example name column"
    data_type = "string"
    is_nullable = false
  }
}
