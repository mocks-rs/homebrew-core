class Mocks < Formula
  desc "Get a mock REST APIs with zero coding within seconds."
  homepage "https://github.com/mocks-rs/mocks"
  url "https://github.com/mocks-rs/mocks/archive/refs/tags/0.3.1.tar.gz"
  sha256 "4f18ba358607b6e196c62598e150e887e5b6ad6468a6dac20b68d576f6d8cd0e"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    (testpath/"storage.json").write("{\"posts\":[],\"comments\":[], \"profile\":{}}")
    
    pid = fork do
      exec bin/"mocks", "-p", port.to_s, "storage.json"
    end
    
    sleep 3
    output = shell_output("curl -sS http://localhost:#{port}/posts")
    assert_match "[]", output
    
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
