job "blender-render-nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta {

  }

  group "agh" {
    task "blender-render" {
      driver = "docker"

      config {
        image          = "redis:7"
        ports          = ["db"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
