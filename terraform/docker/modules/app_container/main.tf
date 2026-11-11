terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_container" "app" {
  name    = var.container_name
  image   = var.image
  restart = "unless-stopped"

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  env = [
    "APP_ENV=${var.environment}",
    "PORT=${var.internal_port}"
  ]
}
