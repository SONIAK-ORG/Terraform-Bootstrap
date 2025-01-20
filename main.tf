provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat_token
}

resource "azuredevops_git_repository" "target_repo" {
  project_id = var.project_id
  name       = var.target_repo_name
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://dev.azure.com/example-org/private-repository.git"
    service_connection_id = azuredevops_serviceendpoint_generic_git.example-serviceendpoint.id
  }
}
