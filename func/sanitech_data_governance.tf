resource "databricks_policy" "example" {
  name = "example-policy"
  description = "Example policy for data governance"
  policy_type = "table"
  policy_statement = <<EOF
{
  "effect": "deny",
  "actions": ["*"],
  "resources": ["table:*"],
  "conditions": {
    "string_equals": {
      "table:database": "example_database",
      "table:name": "example_table"
    }
  }
}
EOF
}

resource "databricks_policy_assignment" "example" {
  policy_id = databricks_policy.example.id
  workspace_principal_name = "example_workspace"
}
