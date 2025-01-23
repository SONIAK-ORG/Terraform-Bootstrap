terraform {
  required_version = ">= 0.12"

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 0.4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
  }
}
