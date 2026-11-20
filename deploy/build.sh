#!/bin/sh
# Build Aspendora's FreshRSS image on docker-apps from the `aspendora` branch of lacymooretx/FreshRSS.
# Usage (on docker-apps): sh /opt/services/freshrss/src/deploy/build.sh
# Result: aspendora/freshrss:<FreshRSS version>-<YYYYMMDD>, also tagged aspendora/freshrss:local.
set -eu
SRC=/opt/services/freshrss/src
if [ -d "$SRC/.git" ]; then git -C "$SRC" fetch -q origin && git -C "$SRC" checkout -q aspendora && git -C "$SRC" reset -q --hard origin/aspendora
else git clone -q -b aspendora https://github.com/lacymooretx/FreshRSS.git "$SRC"; fi
VER=$(sed -n "s/.*FRESHRSS_VERSION', '\([^']*\)'.*/\1/p" "$SRC/constants.php")
TAG="aspendora/freshrss:${VER}-$(date +%Y%m%d)"
docker build --pull -f "$SRC/Docker/Dockerfile" \
  --build-arg CACHE_BUST="$(date +%s)" \
  --build-arg FRESHRSS_VERSION="$VER" \
  --build-arg SOURCE_COMMIT="$(git -C "$SRC" rev-parse HEAD)" \
  -t "$TAG" -t aspendora/freshrss:local "$SRC"
docker run --rm --entrypoint php "$TAG" -r 'echo "PHP ", PHP_VERSION, PHP_EOL;'
echo "Built $TAG"
