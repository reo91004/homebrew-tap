cask "usagi-agent" do
  arch arm: "arm64", intel: "x64"

  version "0.5.0"
  sha256 arm:   "183e6a6fef656a46d827abeb0daef84053df6589e86ec121db212132436b0032",
         intel: "36ceacaa675afd6273c733f7db097c1b934d4f24ff3bc9b0b3dbe3716a25b4ea"

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
