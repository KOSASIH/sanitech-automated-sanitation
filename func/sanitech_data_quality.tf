resource "databricks_notebook" "example" {
  path = "/example/data-quality"
  format = "SOURCE"

  library {
    jar = "com.databricks:spark-xml_2.12:0.13.0"
  }

  library {
    maven = {
      coordinates = "com.databricks:databricks-sql-connector_2.12:2.6.0"
    }
  }
}

resource "databricks_job" "example" {
  name = "example-data-quality-job"

  new_cluster {
    node_type_id = "m5.xlarge"
    autotermination_minutes = 30
  }

  task {
    notebook_task {
      notebook_path = databricks_notebook.example.path
    }
  }
}
