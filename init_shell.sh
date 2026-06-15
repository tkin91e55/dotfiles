#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"


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

function set_default_shell() {
  chsh -s /usr/bin/zsh
}

install_oh_my_zsh
install_powerlevel10k
link_shell_config
set_default_shell

unset install_oh_my_zsh
unset install_powerlevel10k
unset link_shell_config
unset set_default_shell
