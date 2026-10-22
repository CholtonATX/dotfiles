{ config, pkgs, lib, ... }:

let
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
    isDarwin = pkgs.stdenv.isDarwin;
in

{
    home.username = "christian.holton";
    home.homeDirectory = if isDarwin then "/Users/christian.holton" else "/home/christian.holton";
    home.stateVersion = "24.11";
    home.packages = with pkgs; [
        # nix tooling
        nixd

        # frequently used CLI or function pkgs
        ripgrep
        atuin
        fd
        fzf
        lazygit
        gh
        btop
        git
        jq
        bat
        powershell
        pyenv
        wget
        tldr

        # cli tools managed by nixpkgs
        _1password-cli
        nerd-fonts.hack
    ] ++ lib.optionals (!isDarwin) [
        # Homebrew provides these on macOS
        eza
        zoxide
    ];

    fonts.fontconfig.enable = true;
    manual.manpages.enable = false;

    home.sessionVariables = {
        EDITOR = "nano";
        LANG = "en_US.UTF-8";
        CLAUDE_CODE_EFFORT_LEVEL = "high";
        CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING = "1";
        CLAUDE_CODE_SUBAGENT_MODEL = "claude-haiku-4-5-20251001";
        CLAUDE_CODE_MAX_OUTPUT_TOKENS = "16384";
        CLAUDE_CODE_NO_FLICKER = "1";
        # CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        BASH_MAX_TIMEOUT_MS = "1800000";
    } // lib.optionalAttrs isDarwin {
        HOMEBREW_REQUIRE_TAP_TRUST = "1";
        PYTORCH_ENABLE_MPS_FALLBACK = "1";
    };

    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initContent = ''
            bindkey '^f' autosuggest-accept

        '' + lib.optionalString isDarwin ''
            # PATH additions
            export PATH="/opt/homebrew/bin:$PATH"
            export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
            export PATH="$PATH:/Users/christian.holton/ACLI"
            export PATH="$PATH:/Library/Nessus/run/sbin"

        '' + ''
            # pyenv
            export PYENV_ROOT="$HOME/.pyenv"
            [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
            eval "$(pyenv init -)"

            # Tool initializations
            eval "$(zoxide init zsh)"
            eval "$(atuin init zsh)"
            fpath+=${pkgs.nix}/share/zsh/site-functions
            autoload -Uz compinit && compinit
            eval "$(op completion zsh)"; compdef _op op
            eval $(thefuck --alias)

            # FZF keybindings and completion
            [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

            # 1Password plugins
            [[ -f /Users/christian.holton/.config/op/plugins.sh ]] && source /Users/christian.holton/.config/op/plugins.sh

            # Google Cloud SDK
            if [ -f '/Users/christian.holton/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/christian.holton/Downloads/google-cloud-sdk/path.zsh.inc'; fi
            if [ -f '/Users/christian.holton/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/christian.holton/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

            # VSCode shell integration
            [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "code" ]] && . "$(code --locate-shell-integration-path zsh)"

            # History settings
            setopt HIST_IGNORE_SPACE
            setopt HIST_IGNORE_DUPS
            setopt HIST_REDUCE_BLANKS

            # Creates a new dir and enters it
            mkcd() {
              mkdir "$1" && cd "$1"
            }

            # Universal unarchiver
            extract() {
              if [ -f "$1" ]; then
                case "$1" in
                  *.tar.bz2) tar xjf "$1" ;;
                  *.tar.gz)  tar xzf "$1" ;;
                  *.bz2)     bunzip2 "$1" ;;
                  *.rar)     unrar x "$1" ;;
                  *.gz)      gunzip "$1" ;;
                  *.tar)     tar xf "$1" ;;
                  *.tbz2)    tar xjf "$1" ;;
                  *.tgz)     tar xzf "$1" ;;
                  *.zip)     unzip "$1" ;;
                  *.7z)      7z x "$1" ;;
                  *)         echo "unknown archive" ;;
                esac
              fi
            }

            # Really clean terminal window
            cls() {
              clear && printf '\e[3J'
            }

            # Safe rm with confirmation
            rm() {
              command ls -FCsd -- "$@"
              read "ans?Delete? [y/N] "
              if [ "$ans" = "y" ]; then
                command rm -rf -- "$@"
              fi
            }

            # Run a command with secrets from ~/secrets-refs/<name>.env injected
            opr() {
              local service=$1
              shift
              local envfile="$HOME/secrets-refs/''${service}.env"
              if [[ ! -f "$envfile" ]]; then
                echo "No env file: $envfile" >&2
                echo "Available:" >&2
                ls -1 "$HOME/secrets-refs/" | sed 's/.env$//' >&2
                return 1
              fi
              op run --env-file="$envfile" -- "$@"
            }
        '';
        shellAliases = {
            ls = "eza --icons --group-directories-first";
            ll = "eza -lah --icons";
            cat = "bat";
            cd = "z";
            tree = "ls -T";
            man = "tldr";
            g = "git";
            cc = "cd ~/git && claude";
            gam = "${config.home.homeDirectory}/bin/gamadv-xtd3/gam";
            condanightly = "cd ~ && conda install pytorch torchvision torchaudio -c pytorch-nightly && python importTorchTest.py";
        };
    };

    programs.git = {
      enable = true;
      settings.user.name = "CholtonATX";
      settings.user.email = "christian.holton@portx.io";
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
        character = {
          success_symbol = "[→](purple)";
          error_symbol = "[→](red)";
        };
        cmd_duration.format = "[$duration]($style)";
      };
    };

    # Edit-in-place: The real file stays in my repo, ~/.config just points at it.
    home.file.".config/wezterm".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
}
