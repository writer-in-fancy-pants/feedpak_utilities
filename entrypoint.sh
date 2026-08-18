#!/usr/bin/env bash
set -uo pipefail

INPUT="/input"
OUTPUT="/output"

mkdir -p "$OUTPUT"

if [[ $# -gt 0 ]]; then
    # Explicit PSARC files.
    for input in "$@"; do
        if [[ ! -f "$input" ]]; then
            echo "ERROR: file not found: $input" >&2
            exit 1
        fi

        if [[ "${input,,}" != *.psarc ]]; then
            echo "ERROR: not a .psarc file: $input" >&2
            exit 1
        fi

        stem="$(basename "${input%.*}")"
        output="$OUTPUT/$stem.feedpak"

        echo "Converting $input -> $output"
        python -m psarc2feedpak "$input" -o "$output" || exit $?
    done

    exit 0
fi

# No arguments: recursively process everything under /input.
if [[ ! -d "$INPUT" ]]; then
    echo "ERROR: $INPUT does not exist." >&2
    exit 1
fi

mapfile -d '' files < <(
    find "$INPUT" -type f -iname '*.psarc' -print0
)

if [[ ${#files[@]} -eq 0 ]]; then
    echo "No .psarc files found in $INPUT"
    exit 0
fi

failed=0

for input in "${files[@]}"; do
    relative="${input#"$INPUT"/}"
    relative_dir="$(dirname "$relative")"
    filename="$(basename "$relative")"
    stem="${filename%.*}"

    output_dir="$OUTPUT/$relative_dir"
    output="$output_dir/$stem.feedpak"

    mkdir -p "$output_dir"

    echo
    echo "========================================"
    echo "Input : $relative"
    echo "Output: ${relative_dir}/${stem}.feedpak"
    echo "========================================"

    if ! python -m psarc2feedpak "$input" -o "$output"; then
        echo "FAILED: $relative" >&2
        failed=1
    else
        echo "OK: $relative"
    fi
done

if [[ $failed -ne 0 ]]; then
    echo
    echo "One or more files failed to convert." >&2
    exit 1
fi

echo
echo "All ${#files[@]} PSARC file(s) converted successfully."
