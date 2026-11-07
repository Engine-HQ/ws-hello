#!/bin/sh
# Resolve the checked-out commit from .git without a git binary (detached HEAD or a branch ref).
set -eu
H=$(cat /src/.git/HEAD 2>/dev/null || echo unknown)
case "$H" in
  ref:*) R=${H#ref: }; SHA=$(cat "/src/.git/$R" 2>/dev/null || grep " $R\$" /src/.git/packed-refs 2>/dev/null | cut -d' ' -f1 || echo unknown) ;;
  *) SHA=$H ;;
esac
mkdir -p /tmp/www
printf 'ws-hello ok\nhead_sha=%s\n' "$SHA" > /tmp/www/index.html
exec httpd -f -p 8080 -h /tmp/www
