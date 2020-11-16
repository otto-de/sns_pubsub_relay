terraform {
  backend "gcs" {
    bucket = "tf-state"
    prefix = "sns_pubsub_relay_service"
  }
}