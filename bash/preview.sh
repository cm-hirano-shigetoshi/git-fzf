#!/usr/bin/env bash
set -euo pipefail

unbuffer git diff "$1"

