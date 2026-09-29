#!/usr/bin/env bash

main() {
    local target="$1"
    shift

    local -a coins=("$@")
    local -a minimum=(0) chosen=() result=()
    local amount coin candidate remaining

    if ((target < 0)); then
        printf "target can't be negative\n" >&2
        return 1
    fi

    for coin in "${coins[@]}"; do
        if ((coin <= 0)); then
            printf 'coin values must be positive\n' >&2
            return 1
        fi
    done

    if ((target == 0)); then
        printf '\n'
        return 0
    fi

    for ((amount = 1; amount <= target; amount++)); do
        minimum[amount]=-1

        for coin in "${coins[@]}"; do
            if ((coin > amount)); then
                continue
            fi

            remaining=$((amount - coin))

            if ((minimum[remaining] == -1)); then
                continue
            fi

            candidate=$((minimum[remaining] + 1))

            if ((minimum[amount] == -1 ||
                 candidate < minimum[amount])); then
                minimum[amount]=$candidate
                chosen[amount]=$coin
            fi
        done
    done

    if ((minimum[target] == -1)); then
        printf "can't make target with given coins\n" >&2
        return 1
    fi

    remaining=$target

    while ((remaining > 0)); do
        coin=${chosen[remaining]}
        result+=("$coin")
        remaining=$((remaining - coin))
    done

    printf '%s\n' "${result[@]}" | sort -n | paste -sd ' ' -
}

main "$@"
