# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
cask "ozaos" do
  version "0.1.5"
  sha256 "71b23ceaba530e28d68819821aca18605522637c6f02fe6864642367fb95b23c"

  url "https://github.com/ozaco/apps/releases/download/ozaos-v#{version}/ozaOS-#{version}-arm64.dmg"
  name "ozaOS"
  desc "Desktop window onto a local-first note vault for coding agents"
  homepage "https://github.com/ozaco/apps"

  livecheck do
    url :url
    regex(/^ozaos-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on formula: "ozaco/apps/ozc"

  app "ozaOS.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/ozaOS.app"]
  end

  uninstall quit: "com.ozaco.ozaos"

  zap launchctl: [
        "com.ozaco.ozaos",
        "com.ozaco.ozaosd",
      ],
      trash:     [
        "~/.ozaco/ozaos",
        "~/.ozaco/profiles/local/ozaos.json",
      ]

  caveats <<~EOS
    ozaOS.app is the window. The vault it shows is kept by a daemon, which
    does not come with this cask. ozc installs it, together with the ozaos
    command, and ozc did come with this cask, as the formula it depends on:

      ozc install ozaos

    The window offers to start the daemon once it is installed. To have it
    started at every login:

      ozc ozaos daemon install

    An ozaOS from before there was a daemon kept the vault inside the app.
    One that is still open - it sits in the menu bar, and opens at every
    login - holds the vault: quit it before the daemon is started.
  EOS
end
