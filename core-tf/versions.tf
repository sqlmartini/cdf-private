terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.45.0"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/test/v0.0.1"
  }
}