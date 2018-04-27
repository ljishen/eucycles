#!/usr/bin/env bash

set -eu

if [ "$#" -lt 2 ] || [[ "$1" == -* ]]; then
    cat <<-ENDOFMESSAGE
Usage: ./extract.sh SOURCE DEST CATEGORY
Extract information from SOURCE file and append to the DEST file.
ENDOFMESSAGE
    exit
fi

SOURCE="$1"
DEST="$2"
CATEGORY="${3:-}"

if [ ! -z "$CATEGORY" ]; then
    echo "$CATEGORY,Cycles," >> "$DEST"
    echo "$CATEGORY,Bitrate," >> "$DEST"
fi

# Extract cpu cycles
cycles=$(grep -oP '\d+(?=\s+cycles)' "$SOURCE")

# Extract the aggregate bandwidth "bit/s" for receiver
bitrate=$(grep -oP 'bw=\K[\d.]+' "$SOURCE")

num_lines=$(wc -l < "$DEST")

line_of_cycles=$(( num_lines - 1 ))
sed -i "$line_of_cycles s/$/${cycles},/" "$DEST"

line_of_bitrate=$(( num_lines ))
sed -i "$line_of_bitrate s/$/${bitrate},/" "$DEST"
