# aur-artifactbridge

The recipe for [`artifactbridge-bin`](https://aur.archlinux.org/packages/artifactbridge-bin),
the ArtifactBridge desktop app and CLI, on the Arch User Repository (AUR).

This repository is automated. Each ArtifactBridge stable release dispatches
its tag here. `update-artifactbridge.yml` downloads the release from
`app.artifactbridge.com`, checks its version, channel and SHA-256 digest,
renders the recipe from `template/` and pushes a
`automation/artifactbridge-bin-<version>` branch. The release automation opens
the pull request and merges it once `recipe contract` and `arch package` pass.
`publish-aur.yml` then pushes `PKGBUILD`, `.SRCINFO`, `artifactbridge.install`
and `LICENSE` to the AUR.

Do not edit the root recipe files by hand. `template/` holds vendored copies
of the application repository's templates; see `template/README.md`.

Arch Linux support is best effort. The maintainer is tozes.

## Install

```sh
yay -S artifactbridge-bin
```

## Reporting issues

Open an issue in this repository, or comment on the
[AUR package page](https://aur.archlinux.org/packages/artifactbridge-bin).
