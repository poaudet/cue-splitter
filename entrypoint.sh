#!/bin/bash
set -e

MOUNT_PATH="/music"

find "$MOUNT_PATH" -type d | while read -r dir; do
    cue=$(find "$dir" -maxdepth 1 -iname '*.cue' | head -n 1)

    if [[ -n "$cue" ]]; then
        echo ">>> Processing: $dir"
        cd "$dir" || continue

        # Extract audio filename from cue (after FILE, before WAVE/MP3/etc.)
        cue_file_name=$(grep -i '^FILE ' "$cue" | head -n 1 | cut -d '"' -f2)

        if [[ ! -f "$cue_file_name" ]]; then
            echo "⚠️ Audio file referenced in CUE not found: $cue_file_name"
            continue
        fi

        shnsplit -f "$(basename "$cue")" -o flac "$cue_file_name"
        /usr/local/bin/cuetag.sh "$(basename "$cue")" split-track*.flac
    fi
done