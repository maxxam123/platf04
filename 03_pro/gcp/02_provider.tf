provider "google" {
  project     = "my-project-id"
  region      = "us-central1"
  project     = "my-project-id"
  region      = "us-central1"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
