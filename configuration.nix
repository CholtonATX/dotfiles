{
   # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
   nix.enable = false;

   nixpkgs.config.allowUnfree  = true;
   nixpkgs.hostPlatform       = "aarch64-darwin";

   system.primaryUser = "christian.holton";
   
   users.users."christian.holton" = {
      home = "/Users/christian.holton";
   };
   system.stateVersion = 6;
   system.defaults = {
      NSGlobalDomain = {
         AppleInterfaceStyle = "Dark";
         KeyRepeat = 2;                # Fast key repeat
         InitialKeyRepeat = 15;        # Short key repeat
         _HIHideMenuBar = false;        # auto-hide menu bar 
         AppleShowAllExtensions = true;
      };
      dock.autohide = true;
      finder.FXPreferredViewStyle = "Nlsv";        # list view by default 
      finder.CreateDesktop = false;                # clean Create
      trackpad.Clicking = true;                   # tap to click 
   };
   nix-homebrew = {
      enable = true;
      user = "christian.holton";
      autoMigrate = true;
   };
   homebrew = {
      enable = true;
      onActivation.cleanup = "zap";    # remove anything not listed here
      onActivation.autoUpdate = true;
      onActivation.extraFlags = [ "--force" ];
      taps = [
         "crowdstrike/foundry-cli"
      ];
      brews = [
         "atuin"
         "crowdstrike/foundry-cli/foundry"
         "bat"
         "eza"
         "fzf"
         "nvm"
         "pyenv"
         "starship"
         "tldr"
         "zoxide"
      ];
      casks = [
         "appcleaner"
         "balenaetcher"
         "bbedit"
         "brave-browser"
         "caffeine"
	      "claude-code@latest"
         "cleanshot"
         "font-anka-coder"
         "font-hack-nerd-font"
         "ghostty"
         "grandperspective"
         "hammerspoon"
         "maccy"
         "raycast"
         "rectangle"
         "spotify"
         "visual-studio-code"
         "wezterm"
      ];
   };
   security.pam.services.sudo_local.touchIdAuth = true;
}
