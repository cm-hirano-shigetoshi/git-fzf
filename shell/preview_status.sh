#!/usr/bin/env bash
set -euo pipefail

# M  hoge.sh
# ?? hoge.sh
# A  hoge.sh
# D  hoge.sh
# R  hoge.sh
read x filepath <<< "$1"

function cat_file() {
    if echo "$1" | grep -q '\.gz$'; then
        expanded_path="${1%.gz}"
        if echo "$expanded_path" | grep -qF '.'; then
            ft="${expanded_path##*.}"
        else
            ft='tsv'
        fi
        gzip -dc "$1" | bat -l $ft --color always --plain -n
    else
        bat "$1" --color always --plain -n
    fi
}

function show_dir() {
    ls -lAR --color "$1"
}

if [[ "$x" = "??" ]] || [[ "$x" = "A" ]]; then
    if [[ -f "$filepath" ]]; then
        cat_file "$filepath"
    elif [[ -d "$filepath" ]]; then
        show_dir "$filepath"
    fi
elif [[ "$x" = "R" ]]; then
    # filepath: "README.md -> README.md_"
    filepath=$(echo "$filepath" | sed 's/^.* -> //')
    cat_file "$filepath"
else
    difft_output=$(GIT_EXTERNAL_DIFF='difft --color=always' git diff "$filepath")
    if echo "$difft_output" | grep -q 'No syntactic changes\.$'; then
        echo "[1m[32m[DIFFT] No syntactic changes.[0m"
        echo ''
        git diff --color=always "$filepath"
    elif echo "$difft_output" | grep -q 'exceeded DFT_PARSE_ERROR_LIMIT)$'; then
        echo "[1m[32m[DIFFT] exceeded DFT_PARSE_ERROR_LIMIT.[0m"
        echo ''
        git diff --color=always "$filepath"
    elif echo "$difft_output" | grep -q 'No changes\.$'; then
        echo "[1m[32m[DIFFT] No changes.[0m"
        echo ''
        git diff --color=always "$filepath"
    else
        echo "$difft_output"
    fi
fi

