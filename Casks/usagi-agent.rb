cask "usagi-agent" do
  arch arm: "arm64", intel: "x64"

  version "0.5.2"
  sha256 arm:   "50d4999e08f2e3897f2df11d560194e644249b566cf9041a8b77366da641f734",
         intel: "0b85dbb0fd36a5fe7a2b87ff4934d8400f2dbc9dec0d11d44f93eb86483a2818"

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

  # ad-hoc 서명(개발자 인증서 없음)이라 받은 그대로면 Gatekeeper 가 열지 못하게 막는다
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
