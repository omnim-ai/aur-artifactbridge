#!/usr/bin/env bash
set -euo pipefail

# Fail unless the root recipe is exactly what template/render.sh produces for
# the root PKGBUILD's pkgver, pkgrel and tarball digest. Before the first
# release there is no root recipe at all. .SRCINFO needs makepkg, so the
# Arch job checks it.

cd "$(dirname "$0")/.."
files=(PKGBUILD .SRCINFO artifactbridge.install LICENSE)

if [ ! -e PKGBUILD ]; then
  for file in "${files[@]}"; do
    [ ! -e "$file" ] || { echo "$file exists without a PKGBUILD" >&2; exit 1; }
  done
  echo "No recipe is published yet."
  exit 0
fi
for file in "${files[@]}"; do
  [ -f "$file" ] || { echo "the recipe has no $file" >&2; exit 1; }
done

pkgver="$(sed -n 's/^pkgver=//p' PKGBUILD)"
pkgrel="$(sed -n 's/^pkgrel=//p' PKGBUILD)"
tarball_sha256="$(sed -n "s/^sha256sums=('\([0-9a-f]\{64\}\)'\$/\1/p" PKGBUILD)"
rendered="$(mktemp -d)"
trap 'rm -rf "$rendered"' EXIT
bash template/render.sh "$pkgver" "$tarball_sha256" "$rendered" "$pkgrel"
for file in PKGBUILD artifactbridge.install LICENSE; do
  diff -u "$rendered/$file" "$file" >&2 || { echo "$file is not what template/render.sh produces" >&2; exit 1; }
done
echo "The recipe matches template/ for $pkgver-$pkgrel."
