resource "apache_atlas_entity" "example" {
  name = "example-entity"
  type_name = "dataset"
  attributes = {
    "name" = "example-dataset"
    "description" = "Example dataset for data lineage"
    "created_at" = "2022-01-01T00:00:00Z"
    "updated_at" = "2022-01-01T00:00:00Z"
  }

  relationships {
    relationship_type_name = "lineage"
    start_entity_type_name = "dataset"
    start_entity_id = "example-source-entity"
    end_entity_type_name = "dataset"
    end_entity_id = "example-destination-entity"
  }
}

resource "apache_atlas_entity" "example_source" {
  name = "example-source-entity"
  type_name = "dataset"
  attributes = {
    "name" = "example-source-dataset"
    "description" = "Example source dataset for data lineage"
    "created_at" = "2022-01-01T00:00:00Z"
    "updated_00:00:00Z" = "2022-01-01T00:00:00Z"
  }
}

resource "apache_atlas_entity" "example_destination" {
  name = "example-destination-entity"
  type_name = "dataset"
  attributes = {
    "name" = "example-destination-dataset"
    "description" = "Example destination dataset for data lineage"
    "created_at" = "2022-01-01T00:00:00Z"
    "updated_at" = "2022-01-01T00:00:00Z"
  }
}
