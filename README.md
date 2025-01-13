## About

Sentry Metadata Action for Docker Buildx Bake.

## Usage

### Bake definition

This action also handles a bake definition file that can be used with the Docker Bake action. You just have to declare an empty target named `sentry-metadata-action` and inherit from it.

```hcl
// docker-bake.hcl

target "docker-metadata-action" {}
target "sentry-metadata-action" {}

target "build" {
  inherits = ["docker-metadata-action", "sentry-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm/v6",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386"
  ]
}
```

```yml
name: ci

on:
  push:
    branches:
      - 'main'
    tags:
      - 'v*'
  pull_request:
    branches:
      - 'main'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: |
            name/app
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha

      - name: Sentry meta
        id: sentry-meta
        uses: soramitsukhmer-lab/sentry-metadata-action@v1
        with:
          sentry_org: my-org
          sentry_auth_token: ${{ secrets.SENTRY_AUTH_TOKEN }}

      - uses: docker/bake-action@v2
        with:
          files: |
            ./docker-bake.hcl
            ${{ steps.meta.outputs.bake-file }}
            ${{ steps.sentry-meta.outputs.bake-file }}
          targets: build
```

## Inputs

### `sentry_url` (optional)
The URL of the Sentry instance. Default is `https://sentry.sorakh.app`.

### `sentry_org` (optional)
The organization slug in Sentry. Default to GitHub repository owner.

### `sentry_auth_token` (required)
The Sentry auth token to authenticate with Sentry.

## Outputs
> Output of `docker buildx bake -f sentry-metadata-action.hcl --print sentry-metadata-action` command.

```json
{
  "group": {
    "default": {
      "targets": [
        "sentry-metadata-action"
      ]
    }
  },
  "target": {
    "sentry-metadata-action": {
      "context": ".",
      "dockerfile": "Dockerfile",
      "args": {
        "SENTRY_AUTH_TOKEN_FILE": "/run/secrets/SENTRY_AUTH_TOKEN",
        "SENTRY_ORG": "soramitsukhmer-lab",
        "SENTRY_URL": "https://sentry.sorakh.app"
      },
      "secret": [
        "id=SENTRY_AUTH_TOKEN,env=SENTRY_AUTH_TOKEN"
      ]
    }
  }
}
```
