cask "ozaos" do
  version "0.1.1"
  sha256 "b9c85a91c38d4330d1cd2190d97edbf83ae5992d16461c73008c427f4eab6dfd"

  url "https://github.com/ozaco/apps/releases/download/ozaos-v#{version}/ozaOS-#{version}-arm64.dmg"
  name "ozaOS"
  desc "Local-first note vault for coding agents, over MCP"
  homepage "https://github.com/ozaco/apps"

  livecheck do
    url :url
    regex(/^ozaos-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64

  app "ozaOS.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/ozaOS.app"]
  end

  zap trash: [
    "~/.ozaco/ozaos",
    "~/.ozaco/profiles/local/ozaos.json",
  ]
end
