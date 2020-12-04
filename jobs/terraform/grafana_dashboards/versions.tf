terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
    }
    nomad = {
      source = "hashicorp/nomad"
    }
  }
  required_version = ">= 0.13"
}
