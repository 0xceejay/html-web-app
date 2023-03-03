terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.53.1"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Configure the GCP provider
provider "google" {
  project = var.project-id
  region  = "us-central1"
}