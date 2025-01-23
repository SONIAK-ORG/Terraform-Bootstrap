variable "org_url" {
  description = "Azure DevOps organization URL"
  type        = string
}

variable "pat_token" {
  description = "Personal Access Token for Azure DevOps"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Name of the Azure DevOps project"
  type        = string
}

variable "target_repo_name" {
  description = "Name of the new Git repository to create"
  type        = string
}

variable "source_repo_url" {
  description = "URL of the source repository to import"
  type        = string
}



variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}


variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}







