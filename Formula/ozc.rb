# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
class Ozc < Formula
  desc "Plugin host and installer for what ozaco releases"
  homepage "https://github.com/ozaco/apps"
  url "https://github.com/ozaco/apps/releases/download/ozc-v0.2.3/ozc-0.2.3-darwin-arm64.tar.gz"
  version "0.2.3"
  sha256 "03a4ba4f6d0cfb1df56ba259ef831730b9a0e9192f6a3f26e67492856f36a15d"

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
