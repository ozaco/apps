# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
class Ozc < Formula
  desc "Plugin host and installer for what ozaco releases"
  homepage "https://github.com/ozaco/apps"
  url "https://github.com/ozaco/apps/releases/download/ozc-v0.2.1/ozc-0.2.1-darwin-arm64.tar.gz"
  version "0.2.1"
  sha256 "10b19cfc619c82ad8bc391f166cd55b183eab12737d5c72e2e8fda70438c1af5"

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
