#!/bin/bash

storefile="_block_store"

currently_blocked() {
  check=$(sudo -A goodhosts check "${1}" 2>&1)
  if [[ "${check}" =~ "exists" ]]; then
    return 0
  else
    return 1
  fi
}

was_previously_listed() {
  if grep -Fxq "${1}" "${storefile}"; then
    return 0
  else
    return 1
  fi
}

in_block_list() {
  if grep -Fxq "${1}" "block-list.txt"; then
    return 0
  else
    return 1
  fi
}


remove_from_store() {
  gsed -i "/^${1}$/d" "./${storefile}"
}

while read -r line; do
  if currently_blocked "${line}" && in_block_list "${line}";then
    echo "skipping ${line}"
    continue
  fi
  sudo -A goodhosts add 0.0.0.0 "${line}"
  sudo -A goodhosts add 0.0.0.0 "www.${line}"
  echo "${line}" >> "${storefile}"
done < "./block-list.txt"


while read -r line; do
  if currently_blocked "${line}" && was_previously_listed "${line}" && ! in_block_list "${line}"; then
    sudo -A goodhosts remove "${line}"
    sudo -A goodhosts remove "www.${line}"
    remove_from_store "${line}"
    echo "Removing ${line}"
    continue
  fi
done < "${storefile}"

