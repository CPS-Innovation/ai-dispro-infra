# -------------------------------------------------------------- #

variable "pipeline_name" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "repo_uri" {
  type = string
}

variable "date" {
  type = string
}

variable "run_number" {
  type = string
}

# -------------------------------------------------------------- #

variable "location" {
  type    = string
  default = "uksouth"
}

variable "environment" {
  type = string
}

variable "subscription" {
  type = string
}

variable "sku" {
  type = string
}

variable "static_ip" {
  type = string
}
