#!/bin/bash

cuefile="$1"
shift

meta=$(cueprint -d '%P\n%T\n%p\n%a\n%t\n%n\n' "$cuefile")
echo "$meta" | while read performer; do
  read title
  read album_performer
  read album
  read track
  read number
  file="$1"
  shift
  if [[ -f "$file" ]]; then
    metaflac --remove-all-tags \
      --set-tag="ARTIST=$performer" \
      --set-tag="TITLE=$title" \
      --set-tag="ALBUMARTIST=$album_performer" \
      --set-tag="ALBUM=$album" \
      --set-tag="TRACKNUMBER=$number" \
      "$file"
  fi
done
