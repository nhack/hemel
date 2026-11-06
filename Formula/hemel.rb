# Written by the release pipeline of hemel for v0.1.0-beta.1; do not edit by hand.
class Hemel < Formula
  desc "Terminal client for Bluesky, built around code snippets"
  homepage "https://hemel.app"
  version "0.1.0-beta.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.1/hemel-darwin-arm64.tar.gz"
      sha256 "ba487ae778c22b1fd1e237bf999606723d6708792e552722ccbf6c66ce2f88cb"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.1/hemel-darwin-x64.tar.gz"
      sha256 "24ec3bf1256c1819f9ba5ece43cf38837d6cc29228f947e8cfda8a9b65c9cccb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.1/hemel-linux-arm64.tar.gz"
      sha256 "8a8fe80ea98a39173fe42490e73886b47f0ac359cee5df73918bdb194f6527be"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.1/hemel-linux-x64.tar.gz"
      sha256 "a83dc9c57a346216034005bb766089db407ebdb3571c67089ddc576d5122e6c9"
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
