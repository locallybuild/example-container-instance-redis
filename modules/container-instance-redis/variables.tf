variable "name_prefix" {
  description = "The prefix used for all resources in this example."
  type        = string
}

variable "location" {
  description = "The region where these resources should be deployed."
  type        = string
}

variable "tags" {
  description = "A mapping of tags which should be applied to each of the resources."
  type        = map(string)
  default     = {}
}

variable "container_image" {
  description = <<-EOT
    The application image the container group runs, pulled directly from Docker
    Hub - no registry credentials and no import step.

    The default is a public multi-arch build carrying both linux/amd64 (Azure
    Container Instances) and linux/arm64 (Apple Silicon), so it runs on Locally
    and on Azure alike. It's published from the application repository,
    tombuildsstuff/builder-app.
  EOT
  type        = string
  default     = "docker.io/tombuildsstuff/builder-app:latest"
}
