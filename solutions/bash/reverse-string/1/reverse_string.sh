#!/usr/bin/env bash

main() {
    local input="$1"
    local output=""
    local i

    for ((i = ${#input} - 1; i >= 0; i--)); do
        output+="${input:i:1}"
    done

    printf '%s\n' "$output"
}

main "$@"