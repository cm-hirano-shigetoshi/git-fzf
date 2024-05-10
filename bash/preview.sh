#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(perl -MCwd=realpath -le 'print realpath shift' "$0/..")

function git_status() {
    GIT_EXTERNAL_DIFF='difft --color=always' git diff "$1"
}

function git_log() {
    if [[ "$#" -eq 1 ]]; then
        hash=$(echo "$1" | bash "$SCRIPT_DIR/get_hash.sh")
        if [[ -n "$hash" ]]; then
            git log --color=always -n 1 $hash
        fi
    elif [[ "$#" -eq 2 ]]; then
        hash_1=$(echo "$1" | bash "$SCRIPT_DIR/get_hash.sh")
        hash_2=$(echo "$2" | bash "$SCRIPT_DIR/get_hash.sh")
        if [[ -n "$hash_1" ]] && [[ -n "$hash_2" ]]; then
            echo "git diff $hash_1 $hash_2"
            GIT_EXTERNAL_DIFF='difft --color=always' git diff "$hash_1" "$hash_2"
        fi
    fi
}


if [[ "$1" = "status" ]]; then
    shift
    git_status "$@"
elif [[ "$1" = "log" ]]; then
    shift
    git_log "$@"
fi

