#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# Enable flakes even if nix.conf doesn't (e.g. fresh official-installer setups).
export NIX_CONFIG="extra-experimental-features = nix-command flakes"
if [[ "$(uname)" == "Darwin" ]]; then
  exec sudo env NIX_CONFIG="$NIX_CONFIG" darwin-rebuild switch --flake ~/.dotfiles#dotfiles
else
  exec nix run github:nix-community/home-manager/release-26.05 -- switch --flake ~/.dotfiles#linux-"$(uname -m)"
fi
