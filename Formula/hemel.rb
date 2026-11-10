# Written by the release pipeline of hemel for v0.1.0-beta.3; do not edit by hand.
class Hemel < Formula
  desc "Terminal client for Bluesky, built around code snippets"
  homepage "https://hemel.app"
  version "0.1.0-beta.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.3/hemel-0.1.0-beta.3-darwin-arm64.tar.gz"
      sha256 "4612039cbd7ab104ded29d0cfdfde077e83a13190d621474f951f6d088adb8ac"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.3/hemel-0.1.0-beta.3-darwin-x64.tar.gz"
      sha256 "19b7b45ad14550f133b3c88eb27cf0c8e5c254cf15406ed0557c0fc32dc24185"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.3/hemel-0.1.0-beta.3-linux-arm64.tar.gz"
      sha256 "f9328adfdd1e97b167585fa52077cf72a38bee4de6d7f531c8db04bb669069e5"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.3/hemel-0.1.0-beta.3-linux-x64.tar.gz"
      sha256 "a0f0a7d1dbfe0aa2fcea6c642875d22f27e0cbf1b0e039e42a148321df25ba26"
    end
  end

  def install
    bin.install "hemel", "hemel-mcp"
    prefix.install "LICENSE", "THIRD-PARTY-NOTICES.txt"
  end

  test do
    assert_match "hemel #{version}", shell_output("#{bin}/hemel --version")
  end
end
