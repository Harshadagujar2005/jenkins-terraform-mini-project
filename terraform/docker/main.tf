terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# Reusable module that provisions one application container
module "app" {
  source = "./modules/app_container"

  container_name = var.container_name
  image          = "${var.image_name}:${var.image_tag}"
  internal_port  = 3000
  external_port  = var.external_port
  environment    = var.environment
}
