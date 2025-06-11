#!/bin/bash
set -e

MOUNT_PATH="/music"

find "$MOUNT_PATH" -type d | while read -r dir; do
    cue=$(find "$dir" -maxdepth 1 -iname '*.cue' | head -n 1)
    audio=$(find "$dir" -maxdepth 1 \( -iname '*.flac' -o -iname '*.ape' -o -iname '*.wav' -o -iname '*.wv' -o -iname '*.tta' \) | grep -v '\.cue' | head -n 1)

    if [[ -n "$cue" && -n "$audio" ]]; then
        echo ">>> Processing: $dir"
        cd "$dir" || continue

        shnsplit -f "$(basename "$cue")" -o flac "$(basename "$audio")"
        /usr/local/bin/cuetag.sh "$(basename "$cue")" split-track*.flac
    fi
done
