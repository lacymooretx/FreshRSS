# Aspendora fork of FreshRSS

Runs at https://rss.aspendora.com on docker-apps (`/opt/services/freshrss`), behind oauth2-proxy (Microsoft sign-in, lacy@aspendora.com only).

**Why a fork:** upstream only republishes release images occasionally, so PHP/Debian security fixes can sit unpatched for weeks. We build our own image instead.

- Branch `aspendora` = an upstream release tag plus these changes:
  - `Docker/Dockerfile`: a `CACHE_BUST` arg and `apt-get upgrade`, so every build pulls the latest Debian security updates. The image source label points at this fork.
  - `deploy/build.sh`: builds `aspendora/freshrss:<version>-<date>` and `:local` on docker-apps.
- **Security patch (PHP/OS):** on docker-apps run `sh /opt/services/freshrss/src/deploy/build.sh`, then `cd /opt/services/freshrss && docker compose up -d freshrss`.
- **New FreshRSS release:** `git fetch upstream --tags && git rebase --onto <new-tag> <old-tag> aspendora`, push, then build and deploy as above.
- **Rollback:** set the compose image back to the previous `aspendora/freshrss:<tag>` and run `docker compose up -d freshrss`.
