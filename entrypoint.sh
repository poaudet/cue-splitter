#!/bin/bash
set -e

MOUNT_PATH="/music"

find "$MOUNT_PATH" -type d | while read -r dir; do
    cue=$(find "$dir" -maxdepth 1 -iname '*.cue' | head -n 1)

    if [[ -n "$cue" ]]; then
        echo ">>> Processing: $dir"
        cd "$dir" || continue

        # Extract filename base (without extension) from CUE
        base_audio_name=$(grep -i '^FILE ' "$cue" | head -n 1 | cut -d '"' -f2 | sed 's/\.[^.]*$//')

        # Look for a matching file in the directory, ignoring extension
        audio=$(find . -maxdepth 1 -type f -iname "*.flac" -o -iname "*.ape" -o -iname "*.wav" -o -iname "*.wv" -o -iname "*.tta" \
            -exec basename {} \; | grep -i "^$base_audio_name\." | head -n 1)

        if [[ -z "$audio" ]]; then
            echo "⚠️ No matching audio file for: $base_audio_name"
            continue
        fi

        echo "Using audio file: $audio"

        shnsplit -f "$(basename "$cue")" -o flac "$audio"
        /usr/local/bin/cuetag.sh "$(basename "$cue")" split-track*.flac
    fi
done