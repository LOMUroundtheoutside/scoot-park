#!/usr/bin/env bash
# Publish Scoot Park: save every change and upload it to GitHub Pages.
# Usage: scoot-publish            (uses a dated message)
#        scoot-publish "new tricks"
set -euo pipefail

GAME_DIR="$HOME/Games/scoot-park"
SITE_URL="https://lomuroundtheoutside.github.io/scoot-park/"

cd "$GAME_DIR"

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "The online repo isn't set up yet. Run this once first:"
  echo "  gh repo create scoot-park --public --source . --push && gh api -X POST repos/LOMUroundtheoutside/scoot-park/pages -f 'source[branch]=main' -f 'source[path]=/'"
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "No changes to publish. The live game is already up to date."
  exit 0
fi

msg="${1:-Update $(date '+%Y-%m-%d %H:%M')}"
git commit -q -m "$msg"
git push -q
echo "Published: $msg"
echo "Live in a minute or two at $SITE_URL"
