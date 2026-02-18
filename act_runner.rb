require_relative './utils/macos_codesign.rb'

class ActRunner < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "0.3.0"
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
             when "linux-amd64" then "c14e9e53deaa1bbfadc2c8052e2222a3f7c437a7c0b44bce5fbd49e2d45fd84c"
             when "linux-arm64" then "db70e51bf711e5db3ba6c74439a87ac3bb5711de7d14d18dd74c1fe535cbaa75" # binary
             when "darwin-amd64" then "876d75b8e000233573a4f5a0debcbb7faf532269c8c9ccefc8badf6c552a4877"
             when "darwin-arm64" then "57067f7bf5167d43c0efea9ba3fe452b93e9b44ad953a6fadca3676dd3239517"
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
