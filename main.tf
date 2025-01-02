provider "github" {
  token = var.github_token
}

resource "github_organization" "perpetum" {
  login = var.organization_name
}

resource "github_repository" "perpetum_repo" {
  name       = "perpetum-project"
  description = "perpetum project repository"
  private    = true
  visibility = "private"
}

resource "github_actions_secret" "perpetum_secret" {
  repository = github_repository.perpetum_repo.name
  secret_name = "perpetum_SECRET"
  plaintext_value = var.perpetum_secret_value
}

resource "github_actions_variable" "perpetum_variable" {
  repository = github_repository.perpetum_repo.name
  variable_name = "perpetum_VARIABLE"
  value = var.perpetum_variable_value
}

resource "github_team" "developers" {
  name        = "developers"
  description = "Development team"
  privacy     = "closed"
}

resource "github_team" "devops" {
  name        = "devops"
  description = "DevOps team"
  privacy     = "closed"
}

resource "github_team_membership" "devops_member" {
  team_id    = github_team.devops.id
  username   = "devops-tech"
  role       = "member"
}

resource "github_team_repository" "developers_access" {
  team_id     = github_team.developers.id
  repository  = github_repository.perpetum_repo.name
  permission  = "push"
}

resource "github_team_repository" "devops_access" {
  team_id     = github_team.devops.id
  repository  = github_repository.perpetum_repo.name
  permission  = "maintain"
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "organization_name" {
  description = "Name of the GitHub organization"
  type        = string
}

variable "perpetum_secret_value" {
  description = "Value for the GitHub Actions secret"
  type        = string
}

variable "perpetum_variable_value" {
  description = "Value for the GitHub Actions variable"
  type        = string
}
