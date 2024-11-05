#!/usr/bin/env bash
# https://github.com/mathiasbynens/dotfiles/blob/main/bootstrap.sh
# copy configs directly under ~/

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
  rsync --exclude ".git/" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE" \
    -avh --no-perms . ~;
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

    apt install lua5.4
    Z_LUA_PATH="${HOME}/.local/bin"
    mkdir -p $Z_LUA_PATH
    wget https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua -O $Z_LUA_PATH/z.lua
    chmod +x $Z_LUA_PATH/z.lua
    echo "eval \"\$(lua $Z_LUA_PATH/z.lua --init bash)\"" >> ~/.bashrc
    source ~/.bashrc

  fi;
fi;
unset doIt;
