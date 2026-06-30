#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p kitty imagemagick gnugrep gnused mediainfo ncurses coreutils findutils

set -euo pipefail

# ── helpers ────────────────────────────────────────────────────────────────

is_image_by_ext() {
    local path="$1" ext
    ext="${path##*.}"
    [[ "${ext,,}" =~ ^(jpg|jpeg|png|gif|bmp|tiff|tif|webp|svg|ico|heic|heif|avif)$ ]]
}

# ── collect images ─────────────────────────────────────────────────────────

IMAGE_EXTS=(
    -iname "*.jpg"  -o -iname "*.jpeg" -o -iname "*.png"  -o -iname "*.gif"
    -o -iname "*.bmp"  -o -iname "*.tiff" -o -iname "*.tif" -o -iname "*.webp"
    -o -iname "*.svg"  -o -iname "*.ico"  -o -iname "*.heic" -o -iname "*.heif"
    -o -iname "*.avif"
)

declare -a IMAGES=()

for arg in "$@"; do
    if [[ -d "$arg" ]]; then
        while IFS= read -r -d '' f; do
            IMAGES+=("$f")
        done < <(find "$arg" -type f \( "${IMAGE_EXTS[@]}" \) -print0 2>/dev/null || true)
    elif [[ -f "$arg" ]]; then
        if is_image_by_ext "$arg"; then
            IMAGES+=("$arg")
        fi
    fi
done

declare -a UNIQ=()
declare -A SEEN=()
for img in "${IMAGES[@]}"; do
    if [[ -z "${SEEN[$img]:-}" ]]; then
        UNIQ+=("$img")
        SEEN[$img]=1
    fi
done

IMAGES=("${UNIQ[@]}")

if [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo -e "⚠️N No Image(s) found\! Nothing to do.\n" >&2
    exit 1
    return 1
fi

echo -e "📷  Found ${#IMAGES[@]} Image(s)\!\n"

for idx in "${!IMAGES[@]}"; do
    img="${IMAGES[$idx]}"
    total="${#IMAGES[@]}"

    kitten icat --scale-up=no        \
                --place="$(tput cols)x$(( $(tput lines) - 4 ))@0x0" \
                --transfer-mode=stream \
                --no-trailing-newline=yes \
                --clear=yes            \
                --engine=magick        \
                --align=left           \
                --unicode-placeholder  \
                --stdin=no             \
                "$img" 2>/dev/null || true

    # header info (after --clear=yes so it shows on a fresh screen)
    echo "────────────────────────────────────────────────"
    echo "  [$((idx + 1))/$total]  $img"
    echo "────────────────────────────────────────────────"

    # dimensions via mediainfo, adapted from the original snippet
    dims=""
    if dims_raw=$(mediainfo "$img" 2>/dev/null); then
        width=$(echo "$dims_raw" | grep -oP '^Width\s*:\s*\K\d+' | head -1)
        height=$(echo "$dims_raw" | grep -oP '^Height\s*:\s*\K\d+' | head -1)
        if [[ -n "$width" && -n "$height" ]]; then
            dims="${width}x${height} px"
        fi
    fi
    if [[ -n "$dims" ]]; then
        echo "📐  $dims"
    else
        echo "📐  (dimensions unavailable)"
    fi

    # prompt after each image
    echo ""
    read -n 1 -s -r -p "  ▶  Press any key to continue (q to quit) … "
    echo ""
    if [[ $REPLY == "q" || $REPLY == "Q" ]]; then
        echo "Exiting."
        exit 0
    fi
done

echo "✔  All done."
