#!/usr/bin/env bash

main() {
    local cap1="$1" cap2="$2" goal="$3" start="$4"
    local a b moves key next x y
    local pour12 pour21 head=0
    local -a queue=() candidates=()
    local -A visited=()

    if ((cap1 <= 0 || cap2 <= 0 || goal < 0)); then
        printf 'Invalid bucket size or goal\n' >&2
        return 1
    fi

    # The mandatory first fill counts as action 1.
    case "$start" in
        one) a=$cap1; b=0 ;;
        two) a=0; b=$cap2 ;;
        *)
            printf 'Starting bucket must be one or two\n' >&2
            return 1
            ;;
    esac

    queue+=("$a,$b,1")
    visited["$a,$b"]=1

    while ((head < ${#queue[@]})); do
        IFS=, read -r a b moves <<< "${queue[head]}"
        head=$((head + 1))

        if ((a == goal)); then
            printf 'moves: %d, goalBucket: one, otherBucket: %d\n' \
                "$moves" "$b"
            return 0
        elif ((b == goal)); then
            printf 'moves: %d, goalBucket: two, otherBucket: %d\n' \
                "$moves" "$a"
            return 0
        fi

        # Amount transferred: minimum of source water and free space.
        pour12=$((a < cap2 - b ? a : cap2 - b))
        pour21=$((b < cap1 - a ? b : cap1 - a))

        candidates=(
            "$cap1,$b"
            "$a,$cap2"
            "0,$b"
            "$a,0"
            "$((a - pour12)),$((b + pour12))"
            "$((a + pour21)),$((b - pour21))"
        )

        for next in "${candidates[@]}"; do
            IFS=, read -r x y <<< "$next"

            # Reject the forbidden state.
            if [[ "$start" == "one" ]] && ((x == 0 && y == cap2)); then
                continue
            fi
            if [[ "$start" == "two" ]] && ((y == 0 && x == cap1)); then
                continue
            fi

            key="$x,$y"

            # Skip previously explored states, including unchanged states.
            if [[ -n "${visited[$key]:-}" ]]; then
                continue
            fi

            visited["$key"]=1
            queue+=("$x,$y,$((moves + 1))")
        done
    done

    printf 'invalid goal\n' >&2
    return 1
}

main "$@"