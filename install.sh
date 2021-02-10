#!/bin/bash

temp="/tmp"
release="https://github.com/goodhosts/cli/releases/download/v1.0.7/goodhosts_darwin_amd64.tar.gz"
output="${temp}/goodhosts.tar.gz"
bin_path="/usr/local/bin"
bin_name="goodhosts"

download() {
  wget "${1}" -O "${output}"
}

extract() {
  tar -C "${temp}" -zxf "${1}"
}

install() {
  mv "${temp}/${bin_name}" "${bin_path}/${bin_name}"
}

install_gsed() {
  brew install gnu-sed
}

cleanup() {
  rm "${1}"
}

download "${release}"
extract "${output}"
install
[[ "${BLOCKME_NO_GSED}" = "true" ]] || install_gsed
cleanup "${output}"

