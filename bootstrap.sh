#!/usr/bin/env bash
# https://github.com/mathiasbynens/dotfiles/blob/main/bootstrap.sh
# copy configs directly under ~/

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function link_nvim_config() {
  local nvim_config_dir="${HOME}/.config/nvim"
  local source_nvim_dir="$(pwd)/resources/nvim"

  mkdir -p "${nvim_config_dir}/lua"

  ln -sfn "${source_nvim_dir}/init.vim" "${nvim_config_dir}/init.vim"
  ln -sfn "${source_nvim_dir}/common.vim" "${nvim_config_dir}/common.vim"
  ln -sfn "${source_nvim_dir}/bufsMng.vim" "${nvim_config_dir}/bufsMng.vim"

  for lua_file in "${source_nvim_dir}"/lua/*.lua; do
    ln -sfn "${lua_file}" "${nvim_config_dir}/lua/$(basename "${lua_file}")"
  done
}

function install_terminal_tools() {
  local z_lua_path="${HOME}/.local/bin"
  local z_lua_init='eval "$(lua '"${z_lua_path}"'/z.lua --init bash)"'

  apt install -y lua5.4 ripgrep
  mkdir -p "${z_lua_path}"
  wget https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua -O "${z_lua_path}/z.lua"
  chmod +x "${z_lua_path}/z.lua"

  if ! grep -Fqx "${z_lua_init}" ~/.bashrc; then
    echo "${z_lua_init}" >> ~/.bashrc
  fi

  source ~/.bashrc
}

function doIt() {
  rsync --exclude ".git/" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE" \
    --exclude "resources/nvim/" \
    -avh --no-perms . ~;
  link_nvim_config
  source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
    mkdir -p ~/.vim/autoload
    cp $(pwd)/resources/vim/plug.vim ~/.vim/autoload/

    vi +PlugInstall +qall

    install_terminal_tools

  fi;
fi;
unset link_nvim_config;
unset install_terminal_tools;
unset doIt;
