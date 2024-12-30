variable "GITHUB_REPOSITORY_OWNER" {default = "owner"}

# Variables
variable "SENTRY_URL" { default = "https://sentry.io" }
variable "SENTRY_ORG" { default = "${GITHUB_REPOSITORY_OWNER}"}

# Secrets
variable "SENTRY_AUTH_TOKEN" {}
variable "SENTRY_AUTH_TOKEN_FILE" { default = "/run/secrets/SENTRY_AUTH_TOKEN" }

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
