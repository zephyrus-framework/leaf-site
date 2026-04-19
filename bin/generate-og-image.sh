#!/usr/bin/env bash
# Generate the site OG social card (1200x630) from resources/og-templates/site.html.
# Output: public/assets/images/og-image.png

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/resources/og-templates/site.html"
OUT="$ROOT/public/assets/images/og-image.png"

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

"$CHROME" \
  --headless \
  --disable-gpu \
  --hide-scrollbars \
  --window-size=1200,630 \
  --force-device-scale-factor=2 \
  --screenshot="$OUT" \
  "file://$TEMPLATE" >/dev/null 2>&1

echo "OG image generated: $OUT"
