resource "google_storage_bucket" "bucket" {
  name          = "receive-relay-code-${var.environment}-${var.project_suffix}"
  location      = "EU"
  force_destroy = true
}

data "archive_file" "relay-function-zip" {
  type        = "zip"
  source_dir  = "../../src/"
  output_path = "${path.root}/index.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.relay-function-zip.output_path

}

# name is a unique id and must be unique within a region
resource "google_cloudfunctions_function" "function" {
  for_each              = { for rs in local.relay_settings : "${rs.service_name}-${rs.target_queue_name}" => rs }
  name                  = "${local.service_name}-function-${each.value.service_name}-${var.project_suffix}"
  description           = "Receives SNS Messages and forward to pubusb"
  runtime               = "nodejs10"
  entry_point           = "receiveNotification"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  environment_variables = {
    SNS_TOPIC    = each.value.source_topic_arn
    PUBSUB_TOPIC = each.value.target_queue_name
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  for_each       = { for rs in local.relay_settings : "${rs.service_name}-${rs.target_queue_name}" => rs }
  project        = google_cloudfunctions_function.function[each.key].project
  region         = google_cloudfunctions_function.function[each.key].region
  cloud_function = google_cloudfunctions_function.function[each.key].name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}