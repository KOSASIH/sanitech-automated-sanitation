provider "databricks" {
  alias = "example"
  host = "https://example.databricks.com"
  token = "example_token"
}

resource "databricks_instance_pool" "example" {
  provider = databricks.example
  name = "example-instance-pool"
  instance_profile_id = "example_instance_profile"
  size = "small"
  autoscale = true
  min_idle_instances = 1
  max_capacity = 20
  idleness_timeout_minutes = 30
}

resource "databricks_cluster" "example" {
  provider = databricks.example
  cluster_name = "example-cluster"
  num_workers = 3
  instance_pool_id = databricks_instance_pool.example.id
  spark_version = "9.1.x-scala2.12"
  node_type = "i3.xlarge"
}
