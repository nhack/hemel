# Written by the release pipeline of hemel for v0.1.0-beta.2; do not edit by hand.
class Hemel < Formula
  desc "Terminal client for Bluesky, built around code snippets"
  homepage "https://hemel.app"
  version "0.1.0-beta.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.2/hemel-0.1.0-beta.2-darwin-arm64.tar.gz"
      sha256 "00e12f519b227b064bc5f8e24ce58a801e9bdeddc6f3e0e2fd43f814828246c9"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.2/hemel-0.1.0-beta.2-darwin-x64.tar.gz"
      sha256 "71bec208c972fb237aff1b6173cdde395169eaa30a800c050d6b38edd1f8c21c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.2/hemel-0.1.0-beta.2-linux-arm64.tar.gz"
      sha256 "d92cf58890aaa4d1474cee3e7baece93d32245198901a7d59b1218700ed69f9c"
    end
    on_intel do
      url "https://github.com/nhack/hemel/releases/download/v0.1.0-beta.2/hemel-0.1.0-beta.2-linux-x64.tar.gz"
      sha256 "d484321acd77965b08c7a36e05df220a9d0ee7283f71ecf2a8c9a05111520f89"
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
