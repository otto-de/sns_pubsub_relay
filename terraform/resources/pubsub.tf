resource "google_pubsub_topic" "sns-events" {
  name = "sqs_to_pubsub-queue"
}

resource "google_pubsub_subscription" "queue-sub" {
  name  = "sqs_to_pubsub-queue-subscription"
  topic = google_pubsub_topic.sns-events.name
}