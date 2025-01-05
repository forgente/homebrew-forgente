require_relative './utils/macos_codesign.rb'

class Changelog < Formula
  desc "Generate changelog of gitea repository"
  homepage "https://gitea.com/gitea/changelog"
  version "main"
  license "MIT"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "changelog: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "changelog-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/changelog-tool/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  sha256 @@sha256
  url @@url,
      using: @@using

  def install
    if stable.using.blank?
      filename = Changelog.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "changelog"
  end

  test do
    system "#{bin}/changelog", "--version"
  end
end
