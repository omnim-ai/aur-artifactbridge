#!/usr/bin/env bash
set -euo pipefail

# AI-3580: render the AUR recipe for one release. The output directory holds
# the files the recipe repository publishes: PKGBUILD, artifactbridge.install,
# and LICENSE (the Terms of Service, public/landing/terms.html).
#
# usage: render.sh VERSION TARBALL_SHA256 OUTPUT_DIR [PKGREL]

version="${1:-}"
tarball_sha256="${2:-}"
output="${3:-}"
pkgrel="${4:-1}"
here="$(cd "$(dirname "$0")" && pwd)"
# Vendored: the Terms of Service copy sits beside this script as LICENSE.
terms="$here/LICENSE"

printf '%s' "$version" | grep -Eq '^[0-9]+(\.[0-9]+)*$' || {
  printf 'render.sh: invalid version: %s\n' "$version" >&2; exit 2;
}
printf '%s' "$tarball_sha256" | grep -Eq '^[0-9a-f]{64}$' || {
  printf 'render.sh: invalid tarball SHA-256: %s\n' "$tarball_sha256" >&2; exit 2;
}
printf '%s' "$pkgrel" | grep -Eq '^[1-9][0-9]*$' || {
  printf 'render.sh: invalid pkgrel: %s\n' "$pkgrel" >&2; exit 2;
}
[ -n "$output" ] || { printf 'usage: %s VERSION TARBALL_SHA256 OUTPUT_DIR [PKGREL]\n' "$0" >&2; exit 2; }

mkdir -p "$output"
cp "$terms" "$output/LICENSE"
cp "$here/artifactbridge.install" "$output/artifactbridge.install"
license_sha256="$(sha256sum "$output/LICENSE" | cut -d' ' -f1)"
sed \
  -e "s/@PKGVER@/$version/" \
  -e "s/@PKGREL@/$pkgrel/" \
  -e "s/@TARBALL_SHA256@/$tarball_sha256/" \
  -e "s/@LICENSE_SHA256@/$license_sha256/" \
  "$here/PKGBUILD" > "$output/PKGBUILD"
if grep -q '@[A-Z0-9_]*@' "$output/PKGBUILD"; then
  printf 'render.sh: the PKGBUILD has an unrendered value\n' >&2
  exit 1
fi
