resource "google_kms_key_ring" "example" {
  name     = "example-key-ring"
  location = "US"
}

resource "google_kms_crypto_key" "example" {
  name            = "example-crypto-key"
  key_ring        = google_kms_key_ring.example.self_link
  purpose         = "ENCRYPT_DECRYPT"
  protection_level = "HSM"
}

resource "google_storage_bucket" "example" {
  name     = "example-bucket"
  location = "US"

  encryption {
    kms_key_name = google_kms_crypto_key.example.self_link
  }
}
