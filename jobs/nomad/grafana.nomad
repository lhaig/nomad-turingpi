job "grafana" {
  datacenters = ["vagrant-dc1", "tpi-dc1"]
  group "grafana" {
    count = 1

    task "grafana" {
      template {
        data = <<EOF
- name: 'default'
  org_id: 1
  folder: ''
  type: 'file'
  options:
    folder: '/var/lib/grafana/dashboards'
EOF

        destination = "local/dashboard.yaml"
      }

      driver = "docker"

      config {
        image = "grafana/grafana:7.0.0"
        volumes = [
          "local/datasources:/etc/grafana/provisioning/datasources",
          "local/dashboard.json:/var/lib/grafana/dashboards/default/dashboard.json",
          "local/dashboard.yaml:/etc/grafana/provisioning/dashboards/dashboard.yaml",
        ]

        port_map {
          grafana_ui = 3000
        }
      }

      env {
        GF_AUTH_ANONYMOUS_ENABLED  = "true"
        GF_AUTH_ANONYMOUS_ORG_ROLE = "Editor"
      }

      resources {
        cpu    = 100
        memory = 64
        network {
          mbits = 10
          port "grafana_ui" {}
        }
      }
      service {
        name = "grafana"
        port = "grafana_ui"

        tags = [
            "urlprefix-/grafana strip=/grafana",
            "traefik.enable=true",
            "traefik.tcp.routers.grafana.entrypoints=grafana",
            "traefik.tcp.routers.grafana.rule=HostSNI(`*`)"
        ]
      }
    }
  }
}
