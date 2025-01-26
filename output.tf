output "repository_id" {
  description = "The ID of the created Git repository"
  value       = azuredevops_git_repository.repo_fabric.id
}

output "repository_url" {
  description = "The URL of the created Git repository"
  value       = azuredevops_git_repository.repo_fabric.web_url
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.mi_fabric.client_id
}

output "managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.mi_fabric.principal_id
}

output "service_connection_name" {
  value = azuredevops_serviceendpoint_azurerm.example.name
}
