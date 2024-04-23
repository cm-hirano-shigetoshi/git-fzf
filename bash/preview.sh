#!/usr/bin/env bash
set -euo pipefail

if [[ "$1" = "status" ]]; then
    shift
    unbuffer git diff "$1"
elif [[ "$1" = "log" ]]; then
    shift
    if [[ "$#" -eq 1 ]]; then
        unbuffer git log -p $1
    elif [[ "$#" -eq 2 ]]; then
        git diff "$1" "$2"
    fi
fi

