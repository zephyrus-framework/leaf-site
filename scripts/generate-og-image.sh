#!/usr/bin/env bash
# Generate the site OG social card (1200x630) from resources/og-templates/site.html.
# Output: public/assets/images/og-image.png

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/resources/og-templates/site.html"
OUT="$ROOT/public/assets/images/og-image.png"
TMP="$ROOT/public/assets/images/.og-image.raw.png"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -x "$CHROME" ]; then
  CHROME="$(command -v chromium || command -v google-chrome || true)"
fi
if [ -z "$CHROME" ] || [ ! -x "$CHROME" ]; then
  echo "Chrome not found. Install Google Chrome or Chromium." >&2
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "Template missing: $TEMPLATE" >&2
  exit 1
fi

# Use a larger window than needed — Chrome headless reserves some vertical space,
# which otherwise clips the body bottom. We render into a taller viewport then
# crop to exactly 1200x630.
"$CHROME" \
  --headless \
  --disable-gpu \
  --hide-scrollbars \
  --window-size=1200,900 \
  --screenshot="$TMP" \
  "file://$TEMPLATE" >/dev/null 2>&1

python3 - <<PY
from PIL import Image
im = Image.open("$TMP")
# Crop top 1200x630 (the body renders aligned to top-left)
im.crop((0, 0, 1200, 630)).save("$OUT", "PNG", optimize=True)
PY

rm -f "$TMP"
echo "OG image generated: $OUT"
