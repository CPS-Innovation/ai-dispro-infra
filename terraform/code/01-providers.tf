terraform {

  # The backend configuration defines the Terraform State files need to be stored.
  backend "azurerm" {
  }

  # Terraform configurations must declare which providers they require, so that Terraform can install and use them.
  # Provider requirements are declared in a required_providers block.
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Greater than requests versions newer than the version 2.0 specified in this instance. 
      version = ">= 4.36.0"
    }
  }

}

# The features block is used to customize the behaviour of certain Azure Provider resources.
# The features block is required for AzureRM provider 2.x but not allowed in version 1.x.
provider "azurerm" {
  features {}
}