#!/usr/bin/env bash

set -e

if [ "${EUID}" -ne 0 ]; then
  echo "Run this script with sudo or as root."
  exit 1
fi

if [ "$(uname -s)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS."
    exit 1
  fi

  brew install zsh fzf git curl universal-ctags
elif [ -f /etc/debian_version ]; then
  apt update
  apt install -y zsh fzf git curl universal-ctags
else
  echo "Unsupported OS. This script currently supports macOS and Debian-based systems."
  exit 1
fi
