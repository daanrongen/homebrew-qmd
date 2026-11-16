class Qmd < Formula
  desc "On-device hybrid search for markdown notes, docs and knowledge bases"
  homepage "https://github.com/tobi/qmd"
  # url and sha256 are updated by .github/workflows/update.yml
  url "https://registry.npmjs.org/@tobilu/qmd/-/qmd-2.8.3.tgz"
  sha256 "2e60829913a0c646234a905cefd61043167a1392fdcfd19bc54f890af89ca0f0"
  license "MIT"

  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    # audit rejects the other mac arch's prebuilds
    other_arch = Hardware::CPU.arm? ? "darwin-x64" : "darwin-arm64"
    rm_r libexec.glob("lib/node_modules/@tobilu/qmd/node_modules/**/prebuilds/#{other_arch}{,.node}")
    # pins the node qmd runs under, whatever is first on PATH
    (bin/"qmd").write_env_script libexec/"bin/qmd", PATH: "#{formula_opt_bin("node@24")}:$PATH"
  end

  def caveats
    <<~EOS
      Unofficial tap, not affiliated with tobi/qmd.

      Vector search downloads about 2GB of models to ~/.cache/qmd/models on first use.
      The index lives in ~/.cache/qmd and config in ~/.config/qmd, so clearing them never breaks this install.
    EOS
  end

  test do
    ENV["HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath/".cache"
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["QMD_CONFIG_DIR"] = testpath/".config/qmd"

    assert_match version.to_s, shell_output("#{bin}/qmd --version")

    (testpath/"docs").mkpath
    (testpath/"docs/a.md").write "# Hello\n\nthe quick brown fox\n"
    system bin/"qmd", "collection", "add", testpath/"docs", "--name", "t"
    system bin/"qmd", "update"
    assert_match "a.md", shell_output("#{bin}/qmd search fox")
    assert_match "sqlite-vec", shell_output("#{bin}/qmd doctor")
  end
end
