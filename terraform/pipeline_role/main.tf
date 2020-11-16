provider "google" {
  project = local.project
}

provider "google" {
  alias   = "infra"
  project = "${local.team_name}-infra-${local.project_infra_suffix}"
}