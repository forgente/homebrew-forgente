require_relative './utils/macos_codesign.rb'

class Forgente < Formula
  desc "Forgente - A painless self-hosted Git service"
  homepage "https://github.com/forgente/forgente"
  version "1.26.4-1"
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
             when "linux-amd64" then "dc1f5e6b3a11957343367c47c600d453a74796f88767b5fc2a30ae100621deab"
             when "linux-arm64" then "c4659ad1666b0d9330395ceafcbede4867d1fb40a2eba0ab9d3569dcdf7a5e25"
             when "linux-386" then "14fbf1cc34ddf9796a81c27f7d5f08f2d7f2aa40fa0a6bf16285c443ae5d3c7d"
             when "darwin-10.12-amd64" then "b78a8486a4f91bb5a12994e7b76df80e7aa5b389498f501e8f09a8fda6818c49"
             when "darwin-10.12-arm64" then "1cfdf9c9303fbd4fe5bcb49b9316737f0d0675d08750b1abd60a51a26395fd9d"
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
