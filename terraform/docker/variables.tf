variable "docker_host" {
  description = "Docker daemon socket"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "container_name" {
  description = "Name of the container to create"
  type        = string
  default     = "mini-app"
}

variable "image_name" {
  description = "Docker image name built by Jenkins"
  type        = string
  default     = "mini-app"
}

variable "image_tag" {
  description = "Docker image tag (Jenkins build number)"
  type        = string
  default     = "latest"
}

variable "external_port" {
  description = "Port exposed on the host machine"
  type        = number
  default     = 3000
}

variable "environment" {
  description = "Environment label shown by the app"
  type        = string
  default     = "dev"
}
