class Tzb < Formula
  desc "Two-way sync of PDF highlights and comments between Zotero and Tine"
  homepage "https://github.com/reo91004/tine-zotero"
  url "https://github.com/reo91004/tine-zotero/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "dfdd5cd569df834af3e7eabee8ecfda10092df15ae2dd7856b5d1cce3e81eba2"
  license "AGPL-3.0-only"

  depends_on :macos
  depends_on "pymupdf"
  depends_on "python@3.14"

  def install
    # Pure-Python package; its only dependency (PyMuPDF) comes from the pymupdf formula.
    libexec.install "tzb"
    (bin/"tzb").write <<~SH
      #!/bin/sh
      PYTHONPATH="#{libexec}" exec "#{formula_opt_bin("python@3.14")}/python3.14" -m tzb "$@"
    SH
  end

  service do
    run [opt_bin/"tzb", "run"]
    keep_alive true
    process_type :background
    log_path var/"log/tzb.log"
    error_log_path var/"log/tzb.log"
  end

  test do
    assert_match "two-way sync", shell_output("#{bin}/tzb --help")
    system formula_opt_bin("python@3.14")/"python3.14", "-c", "import pymupdf"
  end
end
