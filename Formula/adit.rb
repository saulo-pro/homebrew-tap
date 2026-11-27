class Adit < Formula
  desc "WireGuard client that keeps several tunnels up, with a menu bar icon and a CLI"
  homepage "https://adit.saulo.pro"
  url "https://github.com/saulo-pro/adit/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "fc801d01c32f504b3264b058be833f8bf2c7eabc73659c8d7d35717daf3e5477"
  license "MIT"
  head "https://github.com/saulo-pro/adit.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"adit"), "./cmd/adit"
    system "go", "build", *std_go_args(ldflags:, output: bin/"aditd"), "./cmd/aditd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"adit-tray"), "./cmd/adit-tray"
  end

  def caveats
    <<~EOS
      adit's service, aditd, runs as root. Install it and the menu bar icon with:
        sudo adit install
      and run that again after every upgrade: it copies aditd to a place only root can change.
      To remove adit, run sudo adit uninstall before brew uninstall adit.
    EOS
  end

  test do
    assert_match "adit #{version}", shell_output("#{bin}/adit version")
    assert_equal version.to_s, shell_output("#{bin}/aditd -version").strip
  end
end
