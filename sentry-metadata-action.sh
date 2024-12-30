#!/bin/bash

# GitHub Actions helpers
gh_group() { echo "::group::$1"; }
gh_group_end() { echo "::endgroup::"; }
gh_set_output() { echo "$1=$2" >> "$GITHUB_OUTPUT"; }
gh_set_env() { 
    export "$1"="$2"
    echo "$1=$2" >> "$GITHUB_ENV";
}

# Inputs
SENTRY_URL=${1:-${SENTRY_URL}}
SENTRY_ORG=${2:-${SENTRY_ORG}}
SENTRY_AUTH_TOKEN=${3:-${SENTRY_AUTH_TOKEN}}

# Main
gh_group "Processing GitHub context"
gh_set_env "SENTRY_URL" "${SENTRY_URL}"
gh_set_env "SENTRY_ORG" "${SENTRY_ORG}"
gh_set_env "SENTRY_AUTH_TOKEN" "${SENTRY_AUTH_TOKEN}"
gh_set_output "bake-file" "${GITHUB_ACTION_PATH}/sentry-metadata-action.hcl"
echo "Output:"
echo "- bake-file = ${GITHUB_ACTION_PATH}/sentry-metadata-action.hcl"
gh_group_end

gh_group "Bake definition"
docker buildx bake -f "${GITHUB_ACTION_PATH}/sentry-metadata-action.hcl" --print sentry-metadata-action
gh_group_end
