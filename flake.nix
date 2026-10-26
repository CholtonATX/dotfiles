{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Linux-cached channel for the standalone home-manager output below.
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, nixpkgs-linux }: {
    # Linux: home-manager switch --flake .#linux-$(uname -m)
    homeConfigurations = builtins.listToAttrs (map (arch: {
      name = "linux-${arch}";
      value = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-linux {
          system = "${arch}-linux";
          config.allowUnfree = true;
        };
        modules = [ ./home.nix ];
      };
    }) [ "x86_64" "aarch64" ]);


    darwinConfigurations."dotfiles" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./configuration.nix 
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs            = true;
          home-manager.useUserPackages          = true;
          home-manager.users."christian.holton" = import ./home.nix;
        }
        ];
    };
  };
}