#!/usr/bin/env bash

set -e

aws sts get-caller-identity &>/dev/null || aws sso login

eval $(aws configure export-credentials --profile bitfreighter-readonlyaccess --format env)

export AWS_DEFAULT_REGION=us-east-2

nono run --profile claude-code-personal --allow-cwd -- $@
