{
  description = "Flameing hot trash";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    catppuccin-toolbox.url = "github:catppuccin/toolbox";
    catppuccin.url = "github:Stonks3141/ctp-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  nixConfig = {
    substituters = [ 
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, nixos-wsl, catppuccin, sops-nix, hyprland, hyprpicker, lanzaboote, ... } @ inputs:
  let
    system = import ./users/isabel/env.nix;
    overlays = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
    pkgs = import nixpkgs {
      config = {
        allowBroken = true;
        allowUnfree = true;
        tarball-ttl = 0;
      };
    };
  in
    {
      nixosConfigurations = {
        "hydra" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/hydra
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            catppuccin.nixosModules.catppuccin
            {
              isabel = {
                isNvidia = false;
                isLaptop = true;
                desktop = {
                  enable = true;
                  hyprland = {
                    enable = true;
                    isNvidia = false;
                    isLaptop = true;
                  };
                };
              }
              home-manager = { 
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  flakePath = "/home/${system.currentUser}/.setup";
                  isNvidia = false;
                  isLaptop = true;
                  inherit system inputs;
                };
              };
            }
          ];
          specialArgs = { inherit system inputs; };
        };
        "amatarasu" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/amatarasu
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            sops-nix.nixosModules.sops
            catppuccin.nixosModules.catppuccin
            {
              isabel = {
                isNvidia = true;
                isLaptop = false;
                desktop = {
                  enable = true;
                  hyprland = {
                    enable = true;
                    isNvidia = true;
                    isLaptop = false;
                  };
                };
              }
              home-manager = { 
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  flakePath = "/home/${system.currentUser}/.setup";
                  isNvidia = true;
                  isLaptop = false;
                  inherit system inputs;
                };
              };
            }
            # ({config, ...}: {
            #     config = {
            #       nixpkgs.overlays = [overlays];
            #     };
            #   })
          ];
          specialArgs = { inherit system inputs; };
        };
        "izanagi" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/izanagi
            inputs.nixos-wsl.nixosModules.wsl
            home-manager.nixosModules.home-manager
            {
              isabel.desktop.enable = false;
              home-manager = { 
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  flakePath = "/home/${system.currentUser}/.setup";
                  inherit system inputs;
                };
              };
            }
          ];
          specialArgs = { inherit system inputs; };
        };
      };
    };

  nixosModules.isabel = import ./modules/;
}
