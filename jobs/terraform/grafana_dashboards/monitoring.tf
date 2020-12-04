
provider "grafana" {
  url  = var.grafana_address
  auth = "admin:admin"
}
resource "grafana_data_source" "prometheus" {
  type       = "prometheus"
  name       = "prometheus"
  url        = var.prometheus_address
  is_default = "true"
}
resource "grafana_dashboard" "Nomad" {
  config_json = file("${path.module}/grafana_dashboards/Nomad.json")
}
resource "grafana_dashboard" "Consul" {
  config_json = file("${path.module}/grafana_dashboards/Consul.json")
}
// resource "grafana_dashboard" "Vault" {
//   config_json = file("${path.module}/grafana_dashboards/Vault.json")
// }
