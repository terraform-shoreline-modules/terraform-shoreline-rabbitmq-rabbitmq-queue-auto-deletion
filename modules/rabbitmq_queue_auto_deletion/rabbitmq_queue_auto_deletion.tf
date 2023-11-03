resource "shoreline_notebook" "rabbitmq_queue_auto_deletion" {
  name       = "rabbitmq_queue_auto_deletion"
  data       = file("${path.module}/data/rabbitmq_queue_auto_deletion.json")
  depends_on = [shoreline_action.invoke_rabbitmq_logs,shoreline_action.invoke_rmqctl_listqueues,shoreline_action.invoke_set_queue_ttl_and_autodelete]
}

resource "shoreline_file" "rabbitmq_logs" {
  name             = "rabbitmq_logs"
  input_file       = "${path.module}/data/rabbitmq_logs.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_logs.sh")
  description      = "Check the RabbitMQ logs for any errors or warnings"
  destination_path = "/tmp/rabbitmq_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rmqctl_listqueues" {
  name             = "rmqctl_listqueues"
  input_file       = "${path.module}/data/rmqctl_listqueues.sh"
  md5              = filemd5("${path.module}/data/rmqctl_listqueues.sh")
  description      = "Check the RabbitMQ queue settings for auto-delete and expiration policies"
  destination_path = "/tmp/rmqctl_listqueues.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "set_queue_ttl_and_autodelete" {
  name             = "set_queue_ttl_and_autodelete"
  input_file       = "${path.module}/data/set_queue_ttl_and_autodelete.sh"
  md5              = filemd5("${path.module}/data/set_queue_ttl_and_autodelete.sh")
  description      = "Review the queue settings and ensure that they are configured appropriately to avoid unexpected auto-deletion, such as setting the queue expiration time or disabling auto-deletion."
  destination_path = "/tmp/set_queue_ttl_and_autodelete.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rabbitmq_logs" {
  name        = "invoke_rabbitmq_logs"
  description = "Check the RabbitMQ logs for any errors or warnings"
  command     = "`chmod +x /tmp/rabbitmq_logs.sh && /tmp/rabbitmq_logs.sh`"
  params      = []
  file_deps   = ["rabbitmq_logs"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_logs]
}

resource "shoreline_action" "invoke_rmqctl_listqueues" {
  name        = "invoke_rmqctl_listqueues"
  description = "Check the RabbitMQ queue settings for auto-delete and expiration policies"
  command     = "`chmod +x /tmp/rmqctl_listqueues.sh && /tmp/rmqctl_listqueues.sh`"
  params      = []
  file_deps   = ["rmqctl_listqueues"]
  enabled     = true
  depends_on  = [shoreline_file.rmqctl_listqueues]
}

resource "shoreline_action" "invoke_set_queue_ttl_and_autodelete" {
  name        = "invoke_set_queue_ttl_and_autodelete"
  description = "Review the queue settings and ensure that they are configured appropriately to avoid unexpected auto-deletion, such as setting the queue expiration time or disabling auto-deletion."
  command     = "`chmod +x /tmp/set_queue_ttl_and_autodelete.sh && /tmp/set_queue_ttl_and_autodelete.sh`"
  params      = ["NAME_OF_THE_QUEUE"]
  file_deps   = ["set_queue_ttl_and_autodelete"]
  enabled     = true
  depends_on  = [shoreline_file.set_queue_ttl_and_autodelete]
}

