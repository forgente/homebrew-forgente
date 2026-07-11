#!/bin/sh

binaries="forgente act_runner"
for bin in ${binaries};do
	file="${bin}.rb"
	case "$bin" in
		forgente)
			git_url="https://github.com/forgente/forgente"
			dl_url="https://dl.forgente.com"
			supported_os="linux-amd64 linux-arm64 linux-386 darwin-10.12-amd64 darwin-10.12-arm64";;
		act_runner)
			git_url="https://gitea.com/gitea/act_runner"
			dl_url="https://dl.gitea.com"
			supported_os="linux-amd64 linux-arm64 darwin-amd64 darwin-arm64";;
		*)
			>&2 echo "Error: unrecognized binary ($bin)"
			exit 1;;
	esac
	latest=$(curl -sL -o /dev/null -w %{url_effective} "${git_url}/releases/latest")
	version="${latest##*/v}"
	echo "update ${bin} version: ${version}"

	file_url="${dl_url}/${bin}/${version}"
	for os in ${supported_os}; do
		sha256_file="${bin}-${version}-${os}.xz.sha256"
		sha256=$(curl -sL "${file_url}/${sha256_file}" | awk '{print$1}')
		echo "update ${bin} os: ${os}, sha256: ${sha256}"
		sed -r "s/^(\s+when \"${os}\" then).*\"(.*)$/\1 \"${sha256}\"\2/" -i "${file}"
	done
	sed -r "s/^(\s+version).*/\1 \"${version}\"/" -i "${file}"
done
