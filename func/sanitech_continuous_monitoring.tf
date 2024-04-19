resource "datadog_monitor" "cpu_high" {
  name               = "SaniTech CPU Usage High"
  type               = "query"
  query              = "avg(last_5m):system.cpu.system.pct{*} by {host} > 80"
  message            = "High CPU usage detected on host {{host}}"
  notify_no_data     = false
  renotify_interval  = 60
  new_host_delay     = 300
  require_fresh_data = true

  tags = [
    "sanitech",
    "environment:production",
  ]
}
