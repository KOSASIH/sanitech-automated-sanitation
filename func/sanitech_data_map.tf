provider "databricks" {
  alias = "example"
  host = "https://example.databricks.com"
  token = "example_token"
}

resource "databricks_table_relation" "example" {
  provider = databricks.example
  parent_table_name = "example_table"
  child_table_name = "example_child_table"
  relation_type = "PARENT_CHILD"
}
