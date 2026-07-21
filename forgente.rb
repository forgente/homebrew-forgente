require_relative './utils/macos_codesign.rb'

class Forgente < Formula
  desc "Forgente - A painless self-hosted Git service"
  homepage "https://github.com/forgente/forgente"
  version "2.0.0"
  license "MIT"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "forgente: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "forgente-#{version}-#{os}-#{arch}"
  @@url = "https://dl.forgente.com/forgente/#{version}/#{@@filename}"
  @@url += ".xz"
  @@using = nil
  depends_on "xz"

  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "ed096d3de878167512c3a8ee8127c09a0583143ee1549200b036c8ce8bc713b6"
             when "linux-arm64" then "c71a2bbb38f37f4f356d10074d6fceca5d99f2b37bbec3261b74cb8cd527b9a0"
             when "linux-386" then "0b9bda0e93ffb779ff93bfb8ab0c49b988f523a343176d601805dadb0127924a"
             when "darwin-10.12-amd64" then "ac9e4f25e1d0daf80edc8d7d2e7b15c499ae69a20e8a650a36c1740b1d6a2d47"
             when "darwin-10.12-arm64" then "98a04b9d919594d0871c5bef1e8fde6b81c087dd8a6c39c4ff2f56a841e8f30b"
             else
               raise "forgente: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
    using: @@using

  conflicts_with "forgente-head", because: "both install forgente binaries"
  def install
    if stable.using.blank?
      filename = Forgente.class_variable_get("@@filename")
    else
      filename = downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "forgente"
  end

  test do
    system "#{bin}/forgente", "--version"
  end
end
