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
	 "herdr"
         "starship"
         "thefuck"
         "tldr"
         "zoxide"
      ];
      casks = [
         "appcleaner"
         "balenaetcher"
         "bbedit"
         "brave-browser"
         "caffeine"
         "cleanshot"
         "cursor"
         "darkmodebuddy"
         "discord"
         "font-anka-coder"
         "font-hack-nerd-font"
         "ghostty"
         "gimp"
         "grandperspective"
         "hammerspoon"
         "maccy"
         "microsoft-teams"
         "miro"
         "notion"
         "raycast"
         "rectangle"
         "spotify"
         "ticktick"
         "tomatobar"
         "visual-studio-code"
         "wezterm"
      ];
   };
   security.pam.services.sudo_local.touchIdAuth = true;
}
