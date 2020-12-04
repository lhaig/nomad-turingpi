job "prometheus" {
  datacenters = ["vagrant-dc1","tpi-dc1"]

  group "prometheus" {
    count = 1

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:v2.18.1"

        args = [
          "--config.file=/etc/prometheus/config/prometheus.yml",
          "--storage.tsdb.path=/prometheus",
          "--web.console.libraries=/usr/share/prometheus/console_libraries",
          "--web.console.templates=/usr/share/prometheus/consoles",
        ]

        volumes = [
          "local/config:/etc/prometheus/config",
        ]

        port_map {
          prometheus_ui = 9090
        }
      }

      template {
        data = <<EOH
---
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
scrape_configs:
  - job_name: 'nomad_metrics'
    scheme: 'http'
    consul_sd_configs:
    - server: 'http://nmd-svr1.fritz.box:8500'
      services: ['nomad-client', "nomad-server"]

    relabel_configs:
    - source_labels: ['__meta_consul_tags']
      regex: '(.*)http(.*)'
      action: keep

    scrape_interval: 5s
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']

  - job_name: 'consul_metrics'
    scheme: 'http'
    consul_sd_configs:
    - server: 'http://nmd-svr1.fritz.box:8500'
      services:
        - 'consul'

    scrape_interval: 5s
    metrics_path: /v1/agent/metrics
    params:
      format: ['prometheus']

    relabel_configs:
    - source_labels: [__address__]
      regex: ^(.*):(.*)$
      target_label: __address__
      replacement: ${1}:8500

    - source_labels: [__meta_consul_node]
      regex: (.*)
      target_label: host
      replacement: ${1}:8500

# https://www.robustperception.io/extracting-labels-from-legacy-metric-names
    metric_relabel_configs:
    - source_labels: [__name__]
      regex: '(consul_memberlist_tcp)_(.*)'
      replacement: '${2}'
      target_label: type
    - source_labels: [__name__]
      regex: '(consul_memberlist_tcp)_(.*)'
      replacement: '${1}_count'
      target_label: __name__

    - source_labels: [__name__]
      regex: '(consul_memberlist_udp)_(.*)'
      replacement: '${2}'
      target_label: type
    - source_labels: [__name__]
      regex: '(consul_memberlist_udp)_(.*)'
      replacement: '${1}_count'
      target_label: __name__

    - source_labels: [__name__]
      regex: '(consul_raft_replication_heartbeat)_(.+)(_\w?)?'
      replacement: '${2}'
      target_label: query
    - source_labels: [__name__]
      regex: '(consul_raft_replication_heartbeat)_(.+)(_\w?)?'
      replacement: '${1}${3}'
      target_label: __name__

    - source_labels: [__name__]
      regex: '(consul_raft_replication_appendEntries_rpc)_(.+)(_\w?)?'
      replacement: '${2}'
      target_label: query
    - source_labels: [__name__]
      regex: '(consul_raft_replication_appendEntries_rpc)_(.+)(_\w?)?'
      replacement: '${1}${3}'
      target_label: __name__

  - job_name: 'prometheus'
    static_configs:
    - targets: ['nmd-clnt1.fritz.box:9090']

EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/prometheus.yml"
      }

      resources {
        cpu    = 100
        memory = 256

        network {
          mbits = 10

          port "prometheus_ui" {}
        }
      }

      service {
        name = "prometheus"
        port = "prometheus_ui"

        tags = [
          "traefik.enable=true",
          "traefik.tcp.routers.prometheus.entrypoints=prometheus",
          "traefik.tcp.routers.prometheus.rule=HostSNI(`*`)"
        ]

        check {
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
