variable "org_url" {
  description = "Azure DevOps organization URL"
  type        = string
}

variable "pat_token" {
  description = "Personal Access Token for Azure DevOps"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "The ID of the Azure DevOps project"
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
