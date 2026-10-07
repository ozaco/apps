# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
set -eu

version="0.2.1"

case "$(uname -s)" in
  Linux) os="linux" ;;
  *)
    echo "ozc: this script installs ozc on Linux. On macOS: brew install ozc" >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64 | amd64)
    arch="x64"
    sha256="14bf26a1f1657146b74a80ffce69e5c5910cb06f735a6d9527679142fcf7d721"
    ;;
  aarch64 | arm64)
    arch="arm64"
    sha256="5192fcdba6f3f0281415385cb6d63446d777d729d36d63b88839c13770974ddb"
    ;;
  *)
    echo "ozc: no ozc is built for $(uname -m)" >&2
    exit 1
    ;;
esac

if [ -z "$sha256" ]; then
  echo "ozc: ozc $version was not released for $os-$arch" >&2
  exit 1
fi

archive="ozc-$version-$os-$arch.tar.gz"
base="${OZC_DOWNLOAD_BASE:-https://github.com/ozaco/apps/releases/download}"
bin="${OZC_BIN_DIR:-$HOME/.local/bin}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

echo "ozc $version for $os-$arch"
curl -fsSL "$base/ozc-v$version/$archive" -o "$work/$archive"

if command -v sha256sum >/dev/null 2>&1; then
  have="$(sha256sum "$work/$archive" | cut -d ' ' -f 1)"
else
  have="$(shasum -a 256 "$work/$archive" | cut -d ' ' -f 1)"
fi

if [ "$have" != "$sha256" ]; then
  echo "ozc: $archive is not the file that was released (its sha256 is $have)" >&2
  exit 1
fi

tar -xzf "$work/$archive" -C "$work"
mkdir -p "$bin"
cp "$work/bin/ozc" "$bin/.ozc.new"
chmod 755 "$bin/.ozc.new"
mv -f "$bin/.ozc.new" "$bin/ozc"

echo "installed $bin/ozc"

case ":$PATH:" in
  *":$bin:"*) ;;
  *) echo "$bin is not on your PATH: add it to run ozc" ;;
esac
