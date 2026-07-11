require_relative './utils/macos_codesign.rb'

class ForgenteHead < Formula
  desc "Forgente - A painless self-hosted Git service (nightly build)"
  homepage "https://github.com/forgente/forgente"
  version "main-nightly"
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

  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  sha256 @@sha256
  url @@url,
      using: @@using

  def install
    if stable.using.blank?
      filename = ForgenteHead.class_variable_get("@@filename")
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
