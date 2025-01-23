provider "azurerm" {
  features {}
}

# Create a new resource group
resource "azurerm_resource_group" "fabric_rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

# Create a managed identity in the new resource group
resource "azurerm_user_assigned_identity" "fabric-identity" {
  name                = "${var.project_name}-identity"
  resource_group_name = azurerm_resource_group.fabric_rg.name
  location            = azurerm_resource_group.fabric_rg.location
}

# Assign the managed identity as a Contributor to the subscription
resource "azurerm_role_assignment" "fabric-Contributor" {
  principal_id         = azurerm_user_assigned_identity.fabric-identity.principal_id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${var.subscription_id}"
}

provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat_token
}

data "azuredevops_project" "project" {
  name = var.project_name
}

# Create a service connection in Azure DevOps using the managed identity
resource "azuredevops_serviceendpoint_azurerm" "fabric-serviceendpoint" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "${var.project_name}-service-connection"
  description           = "Service connection for ${var.project_name}"
  credentials {
    serviceprincipalid  = azurerm_user_assigned_identity.fabric-identity.client_id
    serviceprincipalkey = "" # Managed Identity does not require a key
    tenantid            = var.tenant_id
  }
  azurerm_spn_role_assignment {
    spn_object_id = azurerm_user_assigned_identity.fabric-identity.principal_id
    role_id       = "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor role
  }
}

# Create a Git repository in Azure DevOps and initialize it with content from a source URL
resource "azuredevops_git_repository" "target_repo" {
  project_id = data.azuredevops_project.project.id
  name       = var.target_repo_name
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://github.com/SONIAK-ORG/fabric-setup"
    service_connection_id = azuredevops_serviceendpoint_azurerm.fabric-serviceendpoint.id
  }
}

