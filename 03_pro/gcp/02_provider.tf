provider "google" {
  project     = var.project
  region      = var.region
#  project     = "my-project-id"
#  region      = "us-central1"
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
