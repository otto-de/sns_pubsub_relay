output "invoke_url" {
  value = [
    for rs in local.relay_settings : google_cloudfunctions_function.function["${rs.service_name}-${rs.target_queue_name}"].https_trigger_url
  ]
}