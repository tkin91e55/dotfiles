#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ "${EUID}" -eq 0 ]; then
  echo "Run ./init_shell_packages.sh as root for package installation."
  echo "Run ./init_shell.sh as the target user for oh-my-zsh and theme setup."
  exit 1
fi

function install_oh_my_zsh() {
  local omz_dir="${HOME}/.oh-my-zsh"

  if [ ! -d "${omz_dir}" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "${omz_dir}"
  fi
}

function install_powerlevel10k() {
  local p10k_dir="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

  if [ ! -d "${p10k_dir}" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${p10k_dir}"
  fi
}

function link_shell_config() {
  ln -sfn "$(pwd)/.zshrc" "${HOME}/.zshrc"
  ln -sfn "$(pwd)/.p10k.zsh" "${HOME}/.p10k.zsh"
}

install_oh_my_zsh
install_powerlevel10k
link_shell_config

unset install_oh_my_zsh
unset install_powerlevel10k
unset link_shell_config
