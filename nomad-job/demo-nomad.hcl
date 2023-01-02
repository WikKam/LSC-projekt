job "demo-nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta { }

  group "agh" {
    task "curl" {
      driver = "docker"

      config {
        image          = "alpine/curl:3.14"
        command        = "curl"
        args           = [
          "-I", "https://www.google.com/"
        ]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
