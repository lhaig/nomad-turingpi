
job "redis-job" {
  multiregion {
    strategy {
      max_parallel = 1
      on_failure   = "fail_all"
    }
    region "tpi-region" {
      count       = 3
      datacenters = ["tpi-dc1"]
    }
    region "vgrnt-region" {
      count       = 3
      datacenters = ["vagrant-dc1"]
    }
  }

  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }
  group "cache" {
    count = 1
    network {
      port "db" {
        to = 6379
      }
    }
    service {
      name = "redis-cache"
      tags = ["global", "cache"]
      port = "db"
    }
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 300
    }
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"

        ports = ["db"]
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}
