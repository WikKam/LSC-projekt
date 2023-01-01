job "blender-render-nomad" {
  datacenters = ["dc1"]
  type = "batch"

  group "blender-render-group" {
    count = 2
    task "blender-render-task" {
      driver = "docker"

      config {
        image          = "petroniuss/lcs-blender:latest"
        args           = [
          "--background", "myfile.blend",
          "-E", "CYCLES",
          "--render-output", "./frame-${NOMAD_ALLOC_INDEX}.png",
          "--render-frame", "${NOMAD_ALLOC_INDEX}"
        ]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500 # MHz, tweak this to your needs.
        memory = 512 # MB, this has to be more than 300MB for Blender to work.
      }
    }
  }
}
