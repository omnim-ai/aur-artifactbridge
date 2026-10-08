# ArtifactBridge AUR recipe template (docs/specs/aur-distribution.md).
# packaging/aur/render.sh fills the @...@ values; the recipe repository
# omnim-ai/aur-artifactbridge publishes the rendered copy.
pkgname=artifactbridge-bin
pkgver=0.5.135
pkgrel=1
pkgdesc='ArtifactBridge desktop app and CLI'
arch=('x86_64')
url='https://www.artifactbridge.com/'
license=('LicenseRef-ArtifactBridge')
depends=('webkit2gtk-4.1' 'gtk3' 'libayatana-appindicator' 'polkit')
provides=('artifactbridge')
conflicts=('artifactbridge')
options=('!strip' '!debug')
install=artifactbridge.install
_tarball="ArtifactBridge-Tray-linux-x86_64-${pkgver}.tar.gz"
source=("${_tarball}::https://app.artifactbridge.com/tray/releases/download/tray-v${pkgver}/ArtifactBridge-Tray-linux-x86_64.tar.gz"
        'LICENSE')
noextract=("${_tarball}")
sha256sums=('d81cb03a0f8d571cead015a06d292830dae245495c739bbbf886c3ea5ad81db5'
            '6b90a5c8adc141d17822187c3f02f49e1512e5744f216f75e8ee8e90460c0bb8')

package() {
  tar -xzf "${srcdir}/${_tarball}" -C "${pkgdir}"
  install -Dm644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
