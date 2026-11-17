#!/bin/sh
# Build the whole site into _site/ (index.html, one page per post, and the
# icons) from the Typst sources. Every posts/*.typ that begins with a
# `#let meta = (...)` block is a post; files without one are drafts and are
# skipped. Netlify runs this on every push and publishes _site/.
# Usage: ./build.sh [output-dir]     (default: _site)
#        ./build.sh watch            rebuild _site/ on every save
#        ./build.sh pdf POST         live PDF preview of one post, e.g.
#                                    ./build.sh pdf posts/convex_functions.typ
if [ "$1" = pdf ]; then
    [ -f "$2" ] || { echo "build.sh: no such post: $2" >&2; exit 1; }
    pdf="${TMPDIR:-/tmp}/$(basename "$2" .typ).pdf"
    echo "build.sh: watching $2 -> $pdf" >&2
    exec typst watch --root "$(dirname "$0")" --open "$2" "$pdf"
fi

cd "$(dirname "$0")" || exit 1

posts=""
for f in posts/*.typ; do
    id=$(basename "$f" .typ)
    if [ "$id" = index ]; then
        echo "build.sh: posts/index.typ would overwrite the home page; rename it" >&2
        exit 1
    fi
    if head -n 1 "$f" | grep -q '^#let meta'; then
        posts="$posts${posts:+,}$id"
    else
        echo "build.sh: skipping $id (no meta block, treated as a draft)" >&2
    fi
done

out="_site"
[ "$1" = watch ] || out="${1:-_site}"
mkdir -p "$out"
rm -f "$out"/*.html   # so deleted or drafted posts disappear
cp -r icons favicon.ico site.webmanifest "$out"/

if [ "$1" = watch ]; then
    exec typst watch --features html,bundle -f bundle --input posts="$posts" site.typ "$out"
fi
exec typst compile --features html,bundle -f bundle --input posts="$posts" site.typ "$out"
