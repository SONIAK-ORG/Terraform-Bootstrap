provider "azurerm" {
  features {}
}

provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat_token
}

# Get client configuration
data "azurerm_client_config" "example" {}

# Define resource group with prefix
resource "azurerm_resource_group" "rg_fabric" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Create a managed identity with prefix
resource "azurerm_user_assigned_identity" "mi_fabric" {
  name                = "${var.prefix}-identity"
  resource_group_name = azurerm_resource_group.rg_fabric.name
  location            = azurerm_resource_group.rg_fabric.location
}

# Assign the managed identity as a Contributor to the subscription
resource "azurerm_role_assignment" "ra_fabric_contributor" {
  principal_id         = azurerm_user_assigned_identity.mi_fabric.principal_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${var.subscription_id}"
}

# Data source for the Azure DevOps project
data "azuredevops_project" "project" {
  name = var.project_name
}

# Create a service connection in Azure DevOps using the managed identity
resource "azuredevops_serviceendpoint_azurerm" "se_fabric" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "${var.prefix}-service-connection"
  description           = "Service connection for ${var.project_name}"
  credentials {
    serviceprincipalid  = azurerm_user_assigned_identity.mi_fabric.client_id
    serviceprincipalkey = "" # Managed Identity does not require a key
    tenantid            = data.azurerm_client_config.example.tenant_id
  }
  azurerm_spn_role_assignment {
    spn_object_id = azurerm_user_assigned_identity.mi_fabric.principal_id
    role_id       = "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor role
  }
}

# Create a Git repository in Azure DevOps and initialize it with content from a source URL
resource "azuredevops_git_repository" "repo_fabric" {
  project_id = data.azuredevops_project.project.id
  name       = var.target_repo_name
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://github.com/SONIAK-ORG/fabric-setup"
    service_connection_id = azuredevops_serviceendpoint_azurerm.se_fabric.id
  }
}






output "repository_id" {
  description = "The ID of the created Git repository"
  value       = azuredevops_git_repository.target_repo.id
}

output "repository_url" {
  description = "The URL of the created Git repository"
  value       = azuredevops_git_repository.target_repo.web_url
}



output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.fabric-identity.client_id
}

output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.fabric-identity.principal_id
}

