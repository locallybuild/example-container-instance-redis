# Example: Deploy a Redis-backed app to Container Instances within Locally

This example shows how to deploy [a sample Redis app - `tombuildsstuff/builder-app`](https://hub.docker.com/r/tombuildsstuff/builder-app) to Azure Container Instances, backed by Azure Cache for Redis, on [Locally Build](https://locally.build).

The application is a small demo that reads from and writes to Redis - it stores a value in the cache and serves it back over HTTP. It's a plain [12-factor](https://12factor.net) service: one image, configured entirely through environment variables. The image is built and published from [the application repository](https://github.com/tombuildsstuff/builder-app); this repository is just the infrastructure that runs it.

The app authenticates to Redis with the cache's **access key**, passed to the container as a secure environment variable (there's no managed-identity data path on a Basic cache). It connects over TLS, reading the cache host and SSL port from `REDIS_HOST` and `REDIS_PORT`. On Azure the SSL port is always 6380; on Locally the cache is served on a dynamically-allocated port, which is why the app reads it rather than assuming 6380.

## Requirements

* [Locally Build](https://locally.build).
* Either [HashiCorp Terraform](https://terraform.io) or [OpenTofu](https://opentofu.org).
* Either [Docker](https://www.docker.com) or [Podman](https://podman.io) (recommended).
* The Locally Plugin for `Microsoft.Cache` installed (`locally plugin install --name Microsoft.Cache`).
* The Locally Plugin for `Microsoft.ContainerInstance` installed (`locally plugin install --name Microsoft.ContainerInstance`).

## Running the example

First up, we need to ensure our container runtime (Docker or Podman) is running, then launch Locally:

```bash
locally build
```

With Locally running, in another terminal we can initialise Terraform, which both downloads the providers we need and configures the module for use:

```bash
cd environments/locally
terraform init
```

> [!NOTE]
> It's possible to use OpenTofu here by substituting `terraform` for `tofu`.

With Terraform initialised, we can then provision the example by running:

```bash
locally run terraform apply
```

Once you approve the plan and the resources have been deployed, the application is running at the URL in the outputs:

```
http://locally-example-redis-group-berlin.gondola.locally:8080
```

[Open that URL in a browser](http://locally-example-redis-group-berlin.gondola.locally:8080) and you'll see the value the app has stored in Redis.

---

The container's logs (including each read/write against Redis) can be followed with:

```bash
locally logs
```

## Tearing it down

```bash
cd environments/locally
locally run terraform destroy
```
