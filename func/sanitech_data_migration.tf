resource "mongodbatlas_project" "example" {
  name   = "example-project"
  org_id = mongodbatlas_organization.example.id
}

resource "mongodbatlas_migration" "example" {
  project_id   = mongodbatlas_project.example.id
  target_name  = "example-cluster"
  source_type  = "mongo-migration"
  migration_id = mongodbatlas_migration_job.example.id
}

resource "mongodbatlas_migration_job" "example" {
  project_id           = mongodbatlas_project.example.id
  endpoint_url         = "mongodb://source-cluster-url/admin"
  username             = "source-cluster-user"
  password             = "source-cluster-password"
  collection_data_only = false
  db_filter_mode       = "whitelist"
  databases_to_ignore  = ["admin", "config"]
  databases_to_include  = ["example_db"]
  collections_to_include  = ["example_collection"]
}
