# Francesco Piva - Consensys Assignment

## Assignment Statement

> Create an **automated procedure** for **deploying** and **updating** a
> Backstage instance while **gracefully handling failures**. It would be nice to
> provide a way to **test your procedure locally** (for example, with containers)
> and a **document with instructions** on how to use your method.

## Assignment Requirements

> No particular technology is required you can choose to use whatever you like
> **Your procedure should be resilient to errors** and leave the installation in
> a **working state** even if something wrong happens during an update.

## Getting Started and Requirements

In order to streamline the way we test this, I have used `nix` to handle all
dependencies. Make sure you have a `nix` installed, as well as `direnv` and
once entering this projects' directory all dependencies should be installed.
All dependencies for this project are (should be) included in the `shell.nix`
file.

There's an `init.sh` script that boots up a `minikube` with some addons and
`--cpus=4`.

If you don't want to install or use Nix (you're missing out ;-)) here are the
application I've used to roll out this project.

- `minikube`
- `kubectl`
- `helm`
- `docker`
- `docker-compose`
- `npm` or `npx`

## What's in the init.sh script

- Starting a local `minikube` with 4 CPUs and allowing `--insecure-registry`.
- Installs with `kubectl` Argo-CD and Argo-Rollouts.
- Adds the ArgoCD Application manifest:  `init-files/application-backstage.yaml`
- Builds the Backstage Docker Image and pushes it to the local `minikube` registry.

<!-- ## Backstage init -->
<!---->
<!-- ```bash -->
<!-- npx @backstage/create-app@latest -->
<!-- ``` -->
<!---->
<!-- Add `.dockerignore` to create backstage folder -->
<!---->
<!-- Using the multistage docker build for backstage, so any modification is -->
<!-- properly cached and the final image is smaller. -->
<!---->
<!-- We are using PGSQL for testing as well. We're not going to dwell too much on -->
<!-- how to handle properly secrets in this project, we're simply going to define -->
<!-- them in an `.env` file. -->
<!---->
<!-- ```bash -->
<!-- export POSTGRES_USER=postgres -->
<!-- export POSTGRES_PASSWORD=postgres -->
<!-- export POSTGRES_DB=backstage -->
<!-- export POSTGRES_HOST=db -->
<!-- export POSTGRES_PORT=5432 -->
<!-- ``` -->
<!---->
