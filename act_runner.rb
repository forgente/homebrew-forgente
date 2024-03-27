require_relative './utils/macos_codesign.rb'

class ActRunner < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "0.2.8"
  license "MIT"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "act_runner: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "act_runner-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/act_runner/#{version}/#{@@filename}"
  @@url += ".xz"
  @@using = nil
  depends_on "xz"

  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "84dc6c2492ceaf6af1f9316db9081a7d816625a27d44717f4d6fbae676d02f2f"
             when "linux-arm64" then "adc7f3eb76cb154b149dc2029a2452de8b81306b68928396549ab15359311e93" # binary
             when "darwin-amd64" then "05ace1b9bc1738de641c808fb2a3588febea870a25475ec11ad8137fcec1bd46"
             when "darwin-arm64" then "bba0dbe443f82770f27a77ecf110d48dd1edfa3e2bd3e985e85cceb0664a91e1"
             else
               raise "act_runner: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
    using: @@using

  conflicts_with "act_runner-head", because: "both install act_runner binaries"
  def install
    if stable.using.blank?
      filename = ActRunner.class_variable_get("@@filename")
    else
      filename = downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "act_runner"
  end

  test do
    system "#{bin}/act_runner", "--version"
  end
end
