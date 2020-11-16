locals {
  project              = "${local.team_name}-${var.environment}-${var.project_suffix}"
  team_name            = "meetup"
  service_name         = "sns_pubsub_relay"
  deployment           = "main"
  region               = "europe-west1"
  project_infra_suffix = "zti"

  enable_apis = [
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "pubsub.googleapis.com",
  ]

  relay_settings = [
    {
      service_name      = "dummy_service"
      source_topic_arn  = var.source_topic_arn
      target_queue_name = "sqs_to_pubsub-queue"
    }
  ]
}