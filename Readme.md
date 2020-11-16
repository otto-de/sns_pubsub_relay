# GCP SNS Pub/Sub Relay
This example implemenation shows how to forward messages from **AWS** SNS to **GCP** Pub/Sub.
It uses SNS Push Subscriptions, GCP Cloud Functions and GCP Pub/Sub.

# Scenario
_Given:_ Two independent product teams want to exchange data, Team A (producer) lives 
in **AWS**, Team B (consumer) lives in **GCP**  
_Given:_ Team A uses AWS SNS to publish messages  
_When:_ A message is published via SNS (Team A)  
_Then:_ The message is forwarded to a GCP Cloud Function (Team B)  
_Then:_ The message is stored on GCP Pub/Sub (Team B)
 
# Solution
This repo shows an example how to deploy the resources and the gcp cloud function.
The cloud function is inspired by the offical gcp documentation, see: https://cloud.google.com/community/tutorials/cloud-functions-sns-pubsub 
but updated to the latest dependencies 
Kudos to Preston Holmes (https://github.com/ptone)

# Deployment
```bash
├── src
│    ├── index.js
│    ├── package-lock.json
│    └── package.json
└── terraform
    ├── pipeline_role
    │     ├── backend.tf
    │     ├── constants.tf
    │     ├── live.tfvars
    │     ├── main.tf
    │     ├── nonlive.tfvars
    │     ├── role.tf
    │     └── variables.tf
    ├── resources
    │     ├── backend.tf
    │     ├── constants.tf
    │     ├── live.tfvars
    │     ├── main.tf
    │     ├── nonlive.tfvars
    │     ├── pubsub.tf
    │     └── variables.tf
    └── service
        ├── backend.tf
        ├── constants.tf
        ├── enable_apis.tf
        ├── function.tf
        ├── live.tfvars
        ├── main.tf
        ├── nonlive.tfvars
        ├── output.tf
        └── variables.tf
```

It deployes a bunch of GCP resources:
1. Enables APIs which are needed for the usecase
2. A Pub/Sub Topic for receiving messages
3. A Storage Bucket to upload the function code
4. A Cloud Function (serverless HTTP Function) as HTTPS POST endpoint to receive
 messages
 
Before deployment, you need to exchange the SNS Topics ARN because the cloud function
validates that the request comes from this topic. The topic arn is in the `nonlive.tfvars|live.tfvars` 
as a variable injected into the deployment.

# Usage
1. Get the Source Topic ARN
If this is used in production, you need to exchange the SNS (Publishing) AWS ARN and put it into
`terraform/service/nonlive|live.tfvars` as value for `source_topic_arn = ""`.
2. Deploy the cloud function and send the endpoints url to the consumer
3. Deploy the SNS Subscription on the producers side
in the AWS account with a terraform resource deployment
like this:
```hcl-terraform
variable "gcp_endpoint" {
  default = "https://europe-west1-my_project.cloudfunctions.net/relay_receiver-function-dummy_service"
}

resource "aws_sns_topic_subscription" "gcp_subscription" {
  endpoint               = var.gcp_endpoint
  protocol               = "https"
  topic_arn              = var.my_own_topic_to_subscribe_to
  endpoint_auto_confirms = true
}
``` 