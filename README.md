# dotfiles

Nix config for macOS (nix-darwin + Home Manager + Homebrew) and Linux (standalone Home Manager). Shared user config lives in `home.nix`.

## Prerequisites

Install Nix (official or [Determinate Systems](https://determinate.systems/nix-installer/) installer). `rebuild.sh` enables flakes for its own run. To use flakes elsewhere, add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`.

## macOS

> [!WARNING]
> Homebrew runs with `cleanup = "zap"`: every switch **uninstalls any Homebrew package not declared in `configuration.nix`**, including its data. Add packages there before switching.

First run (installs `darwin-rebuild`):

```sh
git clone https://github.com/CholtonATX/dotfiles ~/github/dotfiles
ln -sfn ~/github/dotfiles ~/.dotfiles
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.dotfiles#dotfiles
```

After that, run `./rebuild.sh`.

## Linux (Ubuntu)

Works on x86_64 and aarch64; `rebuild.sh` picks `linux-x86_64` or `linux-aarch64` from `uname -m`. Requires the username `christian.holton` (hardcoded).

```sh
git clone https://github.com/CholtonATX/dotfiles ~/github/dotfiles
~/github/dotfiles/rebuild.sh
```

Home Manager doesn't change your login shell. To use zsh:

```sh
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
```

## Updating

Edit the config, then run `./rebuild.sh`. It links the repo to `~/.dotfiles`, the path `home.nix` expects, and switches the config for the current OS.
