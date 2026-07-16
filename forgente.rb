require_relative './utils/macos_codesign.rb'

class Forgente < Formula
  desc "Forgente - A painless self-hosted Git service"
  homepage "https://github.com/forgente/forgente"
  version "1.27.0-1"
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
             when "linux-amd64" then "74233f036fbafa97173fe96fd899e83cebdad21096ff8c907d61871a3643bad7"
             when "linux-arm64" then "27a0cc64fb2957dc23166aec1e728fd848112f9d3de476c6bd3362c72c7b13d9"
             when "linux-386" then "ad3b9cc429f37188c8a5290255ea1fd145240b4e148d9d0f7c3b055c3af10c9f"
             when "darwin-10.12-amd64" then "693555eb9ba4168f327db8df91d3edb563fd80a4830c9a32a983cda7db98fe71"
             when "darwin-10.12-arm64" then "a406b1221216fad158c62d96a43f574b5a08dbd964e65fa5ed0b927a1459018f"
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
