class Lancedb < Formula
  desc "Command-line client for LanceDB"
  homepage "https://lancedb.com"
  version "0.42.0-beta.26"
  license "Apache-2.0"

  archive = "https://github.com/lancedb/lancedb/releases/download/v#{version}/lancedb-v#{version}"

  on_macos do
    url "#{archive}-aarch64-apple-darwin.tar.gz"
    sha256 "2bb8ba04dcec1f31d3d7c11b7d3b3631d4d5a60fc34e38fcea760341e5a1f239"

    depends_on arch: :arm64
    depends_on macos: :sonoma
  end

  on_linux do
    on_arm do
      url "#{archive}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be9910da0fe6c63c517ea9c2a292370c1dc0ce0f6e87ff6a1d37eb0443315d60"
    end
    on_intel do
      url "#{archive}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "76d10748a9eefa43d8c6e0eb752da0ef30cf4a5acb4ebeda0261b2e5c7e1e255"
    end
  end

  def install
    if OS.linux? && Hardware::CPU.intel?
      missing = %w[avx2 fma f16c] - Hardware::CPU.flags
      odie "The LanceDB x86-64 binary requires CPU flags: #{missing.join(", ")}" if missing.any?
    end
    bin.install "lancedb"
    doc.install "RUST_THIRD_PARTY_LICENSES.html"
  end

  test do
    assert_equal "lancedb #{version}", shell_output("#{bin}/lancedb --version").strip
    assert_match "local", shell_output("#{bin}/lancedb profile list")
  end
end
