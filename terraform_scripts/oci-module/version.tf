terraform {
  required_providers {
    oci = {
      source  = "registry.terraform.io/hashicorp/oci"
      version = ">=4.92.0"
    }
  }
  required_version = ">= 1.0.0"
}
