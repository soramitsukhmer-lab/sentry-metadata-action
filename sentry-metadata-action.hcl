# The repository owner's name. For example, 'octocat'.
variable "GITHUB_REPOSITORY_OWNER" {}

# Variables
variable "SENTRY_URL" { default = "https://sentry.sorakh.app" }
variable "SENTRY_ORG" { default = "${GITHUB_REPOSITORY_OWNER}"}

# Secrets
variable "SENTRY_AUTH_TOKEN" {}
variable "SENTRY_AUTH_TOKEN_FILE" { default = "/run/secrets/SENTRY_AUTH_TOKEN" }

# Target
target "sentry-metadata-action" {
  secret = [
    "id=SENTRY_AUTH_TOKEN,env=SENTRY_AUTH_TOKEN",
  ]
  args = {
    SENTRY_AUTH_TOKEN_FILE = "${SENTRY_AUTH_TOKEN_FILE}"

    SENTRY_URL = "${SENTRY_URL}"
    SENTRY_ORG = "${SENTRY_ORG}"
  }
}
