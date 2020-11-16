# create a new service account to do the actual set-up of service related resources
# this is called the "pipeline role"
resource "google_service_account" "sns_pubsub_relay_pipeline_service_acccount" {
  account_id   = replace("${local.service_name}-${local.deployment}", "_", "-")
  display_name = "${local.service_name} ${local.deployment}"
  project      = local.project
}

# add roles to pipeline role service account
resource "google_project_iam_member" "serviceaccount_to_roles" {
  for_each = toset(local.roles)
  role     = each.value
  member   = "serviceAccount:${google_service_account.sns_pubsub_relay_pipeline_service_acccount.email}"
}

# allow "service account" to use "itself" with different roles
resource "google_service_account_iam_member" "service_account_token_creator_serviceaccount" {
  provider           = google.infra
  service_account_id = google_service_account.sns_pubsub_relay_pipeline_service_acccount.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${local.infra_pipeline_serviceaccount}-serviceaccount@${local.team_name}-infra-${local.project_infra_suffix}.iam.gserviceaccount.com"
}

resource "google_service_account_iam_member" "service_account_user_serviceaccount" {
  provider           = google.infra
  service_account_id = google_service_account.sns_pubsub_relay_pipeline_service_acccount.id
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${local.infra_pipeline_serviceaccount}-serviceaccount@${local.team_name}-infra-${local.project_infra_suffix}.iam.gserviceaccount.com"
}

# allow group of devs belonging to the team to impersonate as pipeline_role service account
resource "google_service_account_iam_member" "service_account_token_creator" {
  provider           = google.infra
  service_account_id = google_service_account.sns_pubsub_relay_pipeline_service_acccount.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${local.team_name}-infra-owner@otto.de"
}

resource "google_service_account_iam_member" "service_account_user" {
  provider           = google.infra
  service_account_id = google_service_account.sns_pubsub_relay_pipeline_service_acccount.id
  role               = "roles/iam.serviceAccountUser"
  member             = "group:${local.team_name}-infra-owner@otto.de"
}

data "google_project" "env_project" {
  project_id = local.project
}

resource "google_project_iam_binding" "pubsub_service_roles" {
  for_each = toset(local.pubsub_roles)
  role     = each.value
  members  = ["serviceAccount:service-${data.google_project.env_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
}

