locals {
  project              = "${local.team_name}-${var.environment}-${var.project_suffix}"
  team_name            = "meetup"
  service_name         = "sns_pubsub_relay"
  deployment           = basename(path.cwd)
  project_infra_suffix = "" # only if needed
  infra_pipeline_serviceaccount = "my-pipeline-serviceaccount"
  roles = [
    "roles/iam.roleAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
    "roles/cloudfunctions.admin",
    "roles/pubsub.admin",
    "roles/monitoring.editor",    # to create alerts, and metrics dashboard
    "roles/compute.securityAdmin" # we probably only need compute.regionOperations.get
  ]

  # roles for the pubsub service account
  pubsub_roles = [
    "roles/iam.serviceAccountTokenCreator",
    "roles/pubsub.publisher",
    "roles/pubsub.subscriber"
  ]
}
