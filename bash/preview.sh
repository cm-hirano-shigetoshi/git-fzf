#!/usr/bin/env bash
set -euo pipefail

function git_status() {
    GIT_EXTERNAL_DIFF='difft --color=always' git diff "$1"
}

function git_log() {
    if [[ "$#" -eq 1 ]]; then
        git log --color=always -n 1 $1
    elif [[ "$#" -eq 2 ]]; then
        GIT_EXTERNAL_DIFF='difft --color=always' git diff "$1" "$2"
    fi
}


if [[ "$1" = "status" ]]; then
    shift
    git_status "$@"
elif [[ "$1" = "log" ]]; then
    shift
    git_log "$@"
fi

