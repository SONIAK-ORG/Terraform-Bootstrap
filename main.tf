provider "azuredevops" {
  org_service_url       = var.org_url
  personal_access_token = var.pat_token
}


data "azuredevops_project" "project" {
  name = var.project_name
}

resource "azuredevops_git_repository" "target_repo" {
  project_id = data.azuredevops_project.project.id
  name       = var.target_repo_name
  initialization {
    init_type             = "Import"
    source_type           = "Git"
    source_url            = "https://github.com/SONIAK-ORG/avm-deploy"
    #service_connection_id = azuredevops_serviceendpoint_generic_git.example-serviceendpoint.id
  }
}
