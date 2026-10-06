# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
class Ozc < Formula
  desc "Plugin host and installer for what ozaco releases"
  homepage "https://github.com/ozaco/apps"
  url "https://github.com/ozaco/apps/releases/download/ozc-v0.2.0/ozc-0.2.0-darwin-arm64.tar.gz"
  version "0.2.0"
  sha256 "3512585db69b56176d0d0ecca6af5d4df7a1ae8639a07f54478dfc1b18441ed8"

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
