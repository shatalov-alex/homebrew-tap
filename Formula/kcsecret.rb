class Kcsecret < Formula
  desc "Developer secrets in a Touch ID keychain, loaded per project by direnv"
  homepage "https://github.com/shatalov-alex/kcsecret"
  url "https://github.com/shatalov-alex/kcsecret/releases/download/v1.0.0/kcsecret-v1.0.0-macos-universal.tar.gz"
  sha256 "8535fa76c87474c3a9e9ca562406617662ccb2b65c56ae77a05b9302107c570a"
  license "MIT"

  depends_on :macos

  # The ksecret shortcut and tab completion
  resource "ksecret.zsh" do
    url "https://raw.githubusercontent.com/shatalov-alex/kcsecret/v1.0.0/shell/ksecret.zsh"
    sha256 "b9923a1b55a0766b827cc631669fc49f16399a2f1de17c39e75ddc3cdb554731"
  end

  def install
    # The release binary is installed as is, keeping its signature: the keychain trusts kcsecret
    # by it, so upgrades never make macOS ask for the keychain password again.
    bin.install "kcsecret"
    pkgshare.install resource("ksecret.zsh")
  end

  def caveats
    <<~EOS
      For the ksecret shortcut and tab completion, add to ~/.zshrc:
        source #{opt_pkgshare}/ksecret.zsh

      kcsecret loads secrets per project through direnv: brew install direnv
    EOS
  end

  test do
    assert_equal "kcsecret #{version}", shell_output("#{bin}/kcsecret --version").strip
    assert_match "kcsecret Self-Signed", shell_output("codesign -dvv #{bin}/kcsecret 2>&1")
  end
end
