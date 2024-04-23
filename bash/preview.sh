#!/usr/bin/env bash
set -euo pipefail

function git_status() {
    unbuffer git diff "$1" | tr -d '\r'
}

function git_log() {
    if [[ "$#" -eq 1 ]]; then
        unbuffer git log -n 1 $1 | tr -d '\r'
    elif [[ "$#" -eq 2 ]]; then
        unbuffer git diff "$1" "$2" | tr -d '\r'
    fi
}


if [[ "$1" = "status" ]]; then
    shift
    git_status "$@"
elif [[ "$1" = "log" ]]; then
    shift
    git_log "$@"
fi

