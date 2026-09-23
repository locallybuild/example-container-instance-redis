locals {
  # The container group name, used both as the resource name and to compose the
  # public URL below.
  container_group_name = "${var.name_prefix}-group"

  # The port the application listens on inside the container, which is also the
  # port Locally makes it reachable on. The builder-app serves plain HTTP here.
  app_port = 8080

  # The address a browser reaches the application on.
  #
  # Gondola publishes a container group at <group>-<location>.gondola.locally and
  # routes to the container by that name. Unlike App Service there's no TLS front
  # door, so the application is reached over plain HTTP on its own port. On Azure
  # this would instead be http://<dns label>.<region>.azurecontainer.io:<port>.
  app_hostname   = "${local.container_group_name}-${var.location}.gondola.locally"
  app_public_url = "http://${local.app_hostname}:${local.app_port}"
}
