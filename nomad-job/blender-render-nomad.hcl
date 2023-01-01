job "blender-render-nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta { }

  group "agh" {
    task "blender-render" {
      driver = "docker"

      config {
        image          = "petroniuss/lcs-blender:latest"
        args           = [
          "--background", "myfile.blend",
          "-E", "CYCLES",
          "--render-output", "./frame-$(JOB_COMPLETION_INDEX).png",
          "--render-frame", "$(JOB_COMPLETION_INDEX)"
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
