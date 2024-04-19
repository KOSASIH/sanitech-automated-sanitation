provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "sanitech_telemetry" {
  name = "sanitech-telemetry"
}

resource "aws_cloudwatch_log_stream" "sanitech_telemetry" {
  name           = "sanitech-telemetry"
  log_group_name = aws_cloudwatch_log_group.sanitech_telemetry.name
}

resource "aws_iot_thing" "sanitech_device" {
  name = "sanitech-device"
}

resource "aws_iot_topic_rule" "sanitech_telemetry" {
  name        = "sanitech-telemetry"
  topic_rule_payload = jsonencode({
    sql = "SELECT * FROM 'sanitech/telemetry'"
    actions = [{
      cloudwatch = {
        log_group_name = aws_cloudwatch_log_group.sanitech_telemetry.name
        log_stream_name = aws_cloudwatch_log_stream.sanitech_telemetry.name
      }
    }]
  })
}

resource "aws_iot_topic_subscription" "sanitech_telemetry" {
  topic = "sanitech/telemetry"
  thing = aws_iot_thing.sanitech_device.name
}
