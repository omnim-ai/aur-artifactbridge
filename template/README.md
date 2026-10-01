# Vendored recipe template

These files are copied from the ArtifactBridge application repository:

| Here | Source |
| --- | --- |
| `PKGBUILD` | `packaging/aur/PKGBUILD` |
| `artifactbridge.install` | `packaging/aur/artifactbridge.install` |
| `render.sh` | `packaging/aur/render.sh` (reads `LICENSE` from this directory) |
| `LICENSE` | `public/landing/terms.html` (the Terms of Service) |

Change them there first, then copy them here. The `recipe contract` check
fails when the root recipe files differ from what `render.sh` produces.
