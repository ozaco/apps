# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
class Ozc < Formula
  desc "Plugin host and installer for what ozaco releases"
  homepage "https://github.com/ozaco/apps"
  url "https://github.com/ozaco/apps/releases/download/ozc-v0.0.1/ozc-0.0.1-darwin-arm64.tar.gz"
  version "0.0.1"
  sha256 "9414d056da733c86c84aed7b3ab2bfaf0dc6f25a49211a19ae6676839aff0e1f"

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
