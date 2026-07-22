require_relative './utils/macos_codesign.rb'

class Forgente < Formula
  desc "Forgente - A painless self-hosted Git service"
  homepage "https://github.com/forgente/forgente"
  version "2.0.1"
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
             when "linux-amd64" then "1abd1aa7f381b939eec91e9778ac2028a00fa7eb934e6f62714fd41af9bc21a0"
             when "linux-arm64" then "a23f25ba53615518fd672ee0b7ec6bcd473b18c02847dccae7650921f0669ba0"
             when "linux-386" then "bd8299e8b6d0f270f365484f5647288fd92a1ae21b7c1d44fefd90ecb40bdbcc"
             when "darwin-10.12-amd64" then "4c78b4e0495733e557bb9e6111602ad590c2467cc4e0b7c2a173ed4b5230bd03"
             when "darwin-10.12-arm64" then "771d58338cd0990c5d9299311a54475512b310cbbbb522e9f1ce84902b1a54d8"
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
