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
