provider "azurerm" {
  features {}
}

resource "azurerm_user_assigned_identity" "fabric-identity" {
  name                = "${var.project_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.fabric-identity.client_id
}

output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.fabric-identity.principal_id
}



resource "azurerm_role_assignment" "fabric-Contributor" {
  principal_id   = azurerm_user_assigned_identity.fabric-identity.principal_id
  role_definition_name = "Contributor"
  scope          = "/subscriptions/${var.subscription_id}"
}










provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat_token
}

data "azuredevops_project" "project" {
  name = var.project_name
}

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
