job "blender-render-nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta { }

  group "agh" {
    task "blender-render" {
      driver = "docker"

      config {
        image          = "alpine/curl:3.14"
        command        = "curl"
        args           = [
          "-s", "https://www.google.com/"
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
