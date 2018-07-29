variable "billing_account" {
  description = "The billing account to use"
}

variable "region" {
  description = "The region to deploy to"
  default = "europe-west1"
}

variable "project_name" {
  description = "The name of the project"
}

variable "bucket" {
  description = "The bucket to use for TF states"
}

variable "folder_name" {
  description = "The folder where to create the project"
}

variable "services"{
  description = "The services to activate"
  type = "list"
  default = ["compute.googleapis.com", "logging.googleapis.com"]
}
