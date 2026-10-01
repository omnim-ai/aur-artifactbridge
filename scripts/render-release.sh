#!/usr/bin/env bash
set -euo pipefail

# Verify one downloaded stable release and render its recipe into the
# repository root (PKGBUILD, artifactbridge.install, LICENSE). RELEASE_DIR
# holds VERSION, RELEASE-METADATA.json, SHA256SUMS and the tarball, downloaded
# from https://app.artifactbridge.com/tray/releases/download/<tag>/.
#
# usage: render-release.sh TAG RELEASE_DIR

tag="${1:-}"
release_dir="${2:-}"
tarball=ArtifactBridge-Tray-linux-x86_64.tar.gz
[ -d "$release_dir" ] || { echo "usage: $0 TAG RELEASE_DIR" >&2; exit 2; }
printf '%s' "$tag" | grep -Eq '^tray-v[0-9]+(\.[0-9]+)*$' || { echo "invalid tag: $tag" >&2; exit 2; }
version="${tag#tray-v}"

[ "$(tr -d '\r\n' < "$release_dir/VERSION")" = "$version" ] ||
  { echo "the release VERSION does not match $tag" >&2; exit 1; }
jq -e --arg version "$version" --arg tarball "$tarball" '
  .schema == 1 and
  .version == $version and
  .channel == "stable" and
  any(.artifacts[];
    .platform == "linux" and
    .architecture == "x86_64" and
    .format == "tarball" and
    .asset_name == $tarball)
' "$release_dir/RELEASE-METADATA.json" >/dev/null ||
  { echo "RELEASE-METADATA.json is not a stable $version release listing $tarball" >&2; exit 1; }
line="$(grep -E "^[0-9a-f]{64}[[:space:]]+[*]?$tarball\$" "$release_dir/SHA256SUMS")" ||
  { echo "SHA256SUMS does not list $tarball" >&2; exit 1; }
(cd "$release_dir" && printf '%s\n' "$line" | sha256sum -c - >/dev/null) ||
  { echo "$tarball does not match SHA256SUMS" >&2; exit 1; }

root="$(cd "$(dirname "$0")/.." && pwd)"
bash "$root/template/render.sh" "$version" "${line%% *}" "$root"
