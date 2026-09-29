#!/usr/bin/env bash

main() {
    local score="$1"
    local action="$2"
    local target="${3:-}"
    local allergies=(
        eggs peanuts shellfish strawberries
        tomatoes chocolate pollen cats
    )
    local output=""
    local i

    case "$action" in
        allergic_to)
            for ((i = 0; i < ${#allergies[@]}; i++)); do
                if [[ "${allergies[i]}" == "$target" ]]; then
                    if ((score & (1 << i))); then
                        printf 'true\n'
                    else
                        printf 'false\n'
                    fi
                    return
                fi
            done
            printf 'false\n'
            ;;

        list)
            for ((i = 0; i < ${#allergies[@]}; i++)); do
                if ((score & (1 << i))); then
                    output+="${allergies[i]} "
                fi
            done
            printf '%s\n' "${output% }"
            ;;
    esac
}

main "$@"