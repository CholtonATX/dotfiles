# dotfiles

Nix config for macOS (nix-darwin + Home Manager + Homebrew) and Linux (standalone Home Manager). Shared user config lives in `home.nix`.

## Prerequisites

Install Nix with flakes enabled. The [Determinate Systems installer](https://determinate.systems/nix-installer/) enables flakes by default. With the official installer, also run:

```sh
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon   # Linux only
```

## macOS

> [!WARNING]
> Homebrew runs with `cleanup = "zap"`: every switch **uninstalls any Homebrew package not declared in `configuration.nix`**, including its data. Add packages there before switching.

First run (installs `darwin-rebuild`):

```sh
git clone https://github.com/CholtonATX/dotfiles ~/github/dotfiles
ln -sfn ~/github/dotfiles ~/.dotfiles
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.dotfiles#dotfiles
```

After that, run `./rebuild.sh`.

## Linux (Ubuntu)

Requires an x86_64 machine and the username `christian.holton`; both are hardcoded.

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
