#!/usr/bin/env bash
set -euo pipefail

GIT_EXTERNAL_DIFF='difft --color=always' git diff "$1"

