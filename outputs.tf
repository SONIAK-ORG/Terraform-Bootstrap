output "repository_id" {
  description = "The ID of the created Git repository"
  value       = azuredevops_git_repository.target_repo.id
}

output "repository_url" {
  description = "The URL of the created Git repository"
  value       = azuredevops_git_repository.target_repo.web_url
}
