{
  imports = [
    ../hosts # the hosts that are used in the system

    ./lib # the lib that is used in the system
    ./modules # nixos and home-manager modules
    ./overlays # overlays that make the system that bit cleaner
    ./pkgs # packages exposed to the flake
    ./programs # programs that run in the dev shell
    ./templates # programing templates for the quick setup of new programing enviorments

    ./args.nix # the base args that is passsed to the flake
    ./systems.nix # the systems that are used in the flake
  ];
}
