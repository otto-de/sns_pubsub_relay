provider "google" {
  alias = "default"
}

data "google_service_account_access_token" "pipeline_service" {
  provider               = google.default
  target_service_account = "${replace("${local.service_name}", "_", "-")}-pipeline-role@${local.team_name}-${var.environment}-${var.project_suffix}.iam.gserviceaccount.com"
  scopes                 = ["cloud-platform"]
  lifetime               = "1800s"
}

provider "google" {
  project      = local.project
  region       = local.region
  access_token = data.google_service_account_access_token.pipeline_service.access_token
}
