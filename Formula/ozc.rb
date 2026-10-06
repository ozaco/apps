# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
class Ozc < Formula
  desc "Plugin host and installer for what ozaco releases"
  homepage "https://github.com/ozaco/apps"
  url "https://github.com/ozaco/apps/releases/download/ozc-v0.0.2/ozc-0.0.2-darwin-arm64.tar.gz"
  version "0.0.2"
  sha256 "ffd37efee384eb7c6813d704c5c37160c4314d4141b08112623728c1be96ecad"

  livecheck do
    url :stable
    regex(/^ozc-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "ozc"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ozc --version").strip
  end
end
