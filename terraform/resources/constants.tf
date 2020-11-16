locals {
  project              = "${local.team_name}-${var.environment}-${var.project_suffix}"
  team_name            = "meetup"
  service_name         = "sns_pubsub_relay"
  deployment           = basename(path.cwd)
  project_infra_suffix = "zti"

}
