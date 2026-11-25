#!/bin/sh
# Build the whole site into _site/ (index.html, one page per post, and the
# icons) from the Typst sources. Every posts/*.typ is a post and must begin
# with a `#let meta = (...)` block; drafts/ is never built. Netlify runs this
# on every push and publishes _site/.
# Usage: ./build.sh [output-dir]     (default: _site)
#        ./build.sh watch            rebuild _site/ on every save
#        ./build.sh pdf POST         live PDF preview of one post, e.g.
#                                    ./build.sh pdf drafts/my_next_post.typ
if [ "$1" = pdf ]; then
    [ -f "$2" ] || { echo "build.sh: no such post: $2" >&2; exit 1; }
    pdf="${TMPDIR:-/tmp}/$(basename "$2" .typ).pdf"
    echo "build.sh: watching $2 -> $pdf" >&2
    exec typst watch --root "$(dirname "$0")" --open "$2" "$pdf"
fi

cd "$(dirname "$0")" || exit 1

# Switch on the hooks in hooks/ (the pre-push check) in every clone that builds
# locally. Netlify builds a fresh clone and never pushes, so skip it there.
if [ -z "$NETLIFY" ] && [ "$(git config core.hooksPath)" != hooks ]; then
    git config core.hooksPath hooks 2>/dev/null && echo "build.sh: enabled the pre-push check in hooks/" >&2
fi

posts=""
for f in posts/*.typ; do
    id=$(basename "$f" .typ)
    if [ "$id" = index ]; then
        echo "build.sh: posts/index.typ would overwrite the home page; rename it" >&2
        exit 1
    fi
    if ! head -n 1 "$f" | grep -q '^#let meta'; then
        echo "build.sh: $f must begin with a #let meta = (...) block" >&2
        echo "          (unfinished? move it to drafts/)" >&2
        exit 1
    fi
    posts="$posts${posts:+,}$id"
done

out="_site"
[ "$1" = watch ] || out="${1:-_site}"
mkdir -p "$out"
rm -f "$out"/*.html   # so deleted posts disappear
cp -r icons fonts favicon.ico site.webmanifest "$out"/

if [ "$1" = watch ]; then
    exec typst watch --features html,bundle -f bundle --input posts="$posts" site.typ "$out"
fi
exec typst compile --features html,bundle -f bundle --input posts="$posts" site.typ "$out"
