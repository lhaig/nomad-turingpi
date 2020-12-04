# This terraform code will deploy a Traefik load balancer instance on each of the Clients.
# It uses the Nomad provider.
# Make sure you have copied the terraform.tfvars.example file and addeed the URL of your cluster

resource "nomad_job" "traefik" {
  jobspec    = file("${path.module}/jobfiles/traefik.nomad")
  // Purge job on destroy
  purge_on_destroy = "true"
}


## You can also embed the job specification in your rterraform code as it is below

// resource "nomad_job" "traefik" {
//   // Purge job on destroy
//   purge_on_destroy = "true"
//   jobspec = <<EOT
// job "traefik" {
//   region      = "global"
//   datacenters = ["vagrant-dc1","tpi-dc1"]
//   type        = "system"

//   group "traefik" {
//     count = 1

//     task "traefik" {
//       driver = "docker"

//       config {
//         image        = "traefik:v2.3"
//         network_mode = "host"

//         volumes = [
//           "local/traefik.toml:/etc/traefik/traefik.toml",
//         ]
//       }

//       template {
//         data = <<EOF
// [entryPoints]
//   [entryPoints.traefik]
//     address = ":8081"

//   [entryPoints.grafana]
//     address = ":3000"

//   [entryPoints.prometheus]
//     address = ":9090"

//   [entryPoints.webapp]
//     address = ":80"

// [api]
//   dashboard = true
//   insecure  = true

// [metrics]
//   [metrics.prometheus]
//     addServicesLabels = true

// # Enable Consul Catalog configuration backend.
// [providers.consulCatalog]
//   prefix           = "traefik"
//   exposedByDefault = false

//   [providers.consulCatalog.endpoint]
//     address = "127.0.0.1:8500"
//     scheme  = "http"
// EOF

//         destination = "local/traefik.toml"
//       }

//       resources {
//         cpu    = 100
//         memory = 128

//         network {
//           mbits = 10

//           port "api" {
//             static = 8081
//           }
//           port "grafana" {
//             static = 3000
//           }
//           port "prometheus" {
//             static = 9090
//           }
//           port "webapp" {
//             static = 80
//           }
//         }
//       }

//       service {
//         name         = "traefik-api"
//         port         = "api"
//         address_mode = "host"

//         check {
//           name     = "alive"
//           type     = "tcp"
//           port     = "api"
//           interval = "10s"
//           timeout  = "2s"
//         }
//       }
//       service {
//         name         = "traefik-webapp"
//         port         = "webapp"
//         address_mode = "host"

//         check {
//           name     = "alive"
//           type     = "tcp"
//           port     = "webapp"
//           interval = "10s"
//           timeout  = "2s"
//         }
//       }
//       service {
//         name         = "traefik-grafana"
//         port         = "grafana"
//         address_mode = "host"

//         check {
//           name     = "alive"
//           type     = "tcp"
//           port     = "grafana"
//           interval = "10s"
//           timeout  = "2s"
//         }
//       }
//       service {
//         name         = "traefik-prometheus"
//         port         = "prometheus"
//         address_mode = "host"

//         check {
//           name     = "alive"
//           type     = "tcp"
//           port     = "prometheus"
//           interval = "10s"
//           timeout  = "2s"
//         }
//       }
//     }
//   }
// }
// EOT
// }