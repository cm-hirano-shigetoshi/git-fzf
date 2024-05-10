#!/usr/bin/env bash
set -euo pipefail

perl -pe 's%^[ *|/\\_]+%%' | awk '{print $1}'

