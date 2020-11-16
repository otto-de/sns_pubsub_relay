resource "google_project_service" "project" {
  for_each = toset(local.enable_apis)
  service  = each.value

  disable_dependent_services = true
}