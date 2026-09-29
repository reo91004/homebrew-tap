class Tzb < Formula
  desc "Two-way sync of PDF highlights and comments between Zotero and Tine"
  homepage "https://github.com/reo91004/tine-zotero"
  url "https://github.com/reo91004/tine-zotero/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "24fdc4c4f7408cec0b8792ae49dff9b72ad1aa0d1d342a76f4e332e8cecec585"
  license "AGPL-3.0-only"

  depends_on :macos
  depends_on "pymupdf"
  depends_on "python@3.14"

  def install
    # Pure-Python package; its only dependency (PyMuPDF) comes from the pymupdf formula.
    # -P: never put the current directory on sys.path, so a local `tzb/` or `json.py` cannot shadow the install.
    libexec.install "tzb"
    (bin/"tzb").write <<~SH
      #!/bin/sh
      PYTHONPATH="#{libexec}" exec "#{formula_opt_bin("python@3.14")}/python3.14" -P -m tzb "$@"
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
