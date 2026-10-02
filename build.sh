#!/bin/sh
# Build the whole site (index.html and thoughts/*.html) from the Typst sources.
# Usage: ./build.sh [output-dir]     (default: the repository root)
# For a live-reloading preview: typst watch --features html,bundle -f bundle site.typ
cd "$(dirname "$0")" || exit 1
exec typst compile --features html,bundle -f bundle site.typ "${1:-.}"
