resource "google_cloud_dlp_inspect_template" "example" {
  parent = "projects/example_project"
  display_name = "example-template"

  info_type_transformations {
    transformations {
      info_type {
        name = "EMAIL_ADDRESS"
      }
      replace_config {
        new_info_type {
          name = "EMAIL_ADDRESS_OBFUSCATED"
        }
      }
    }
  }
}

resource "google_cloud_dlp_job" "example" {
  parent = "projects/example_project"
  display_name = "example-job"

  item {
    storage_config {
      cloud_storage {
        bucket = "example_bucket"
        file_set {
          file_glob = "example_file_pattern"
        }
      }
    }
  }

  dlp_inspect_config {
    inspect_config {
      item_transform_config {
        overwrite_destinations = true

        transform_configs {
          replace_config {
            replace_all_text = true
          }
          extract_info_types_config {
            include_info_types {
              name = "EMAIL_ADDRESS"
            }
          }
        }
      }
    }
  }
}
