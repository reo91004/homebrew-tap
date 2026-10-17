cask "usagi-agent" do
  arch arm: "arm64", intel: "x64"

  version "0.8.0"
  sha256 arm:   "2efcbb372faccc15db306967b948ba7bd574c08ecba468da468f1195da6f9a51",
         intel: "b495205878692157545b26b575bd03265c066324737b0ef7d0c7a0667e5d5ff2"

  url "https://github.com/reo91004/usagi-agent/releases/download/v#{version}/Usagi-#{version}-#{arch}.dmg"
  name "우사기 비서"
  desc "Desktop character assistant for todos, briefings and focus timers"
  homepage "https://github.com/reo91004/usagi-agent"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "우사기.app"
  binary "#{appdir}/우사기.app/Contents/Resources/bin/usagi-run"

  # 애플 공증이 없는 앱(ad-hoc 이나 자체 서명 인증서)이라 받은 그대로면 Gatekeeper 가 열지 못하게 막는다
  postflight_steps do
    run "/usr/bin/xattr", args:           ["-dr", "com.apple.quarantine", "{{appdir}}/우사기.app"],
                          writable_paths: ["우사기.app"],
                          writable_base:  :appdir
  end

  uninstall quit:       "com.cy-agent.desktop",
            login_item: "우사기"

  zap trash: [
    "~/.cy-agent",
    "~/Library/Application Support/cy-agent-desktop",
    "~/Library/Preferences/com.cy-agent.desktop.plist",
    "~/Library/Saved Application State/com.cy-agent.desktop.savedState",
  ]
end
