{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./locale.nix # locale settings
    ./display # display protocol (wayland/xorg)
  ];
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "vscodium";
      SYSTEMD_PAGERSECURE = "true";
      PAGER = "less -FR";
      FLAKE = "${config.modules.system.flakePath}";
    };

    # packages that should be on all deviecs
    systemPackages = with pkgs; [
      git
      curl
      wget
      pciutils
      lshw
    ];

    # disable all packages installed by default, i prefer my own packages
    defaultPackages = [];

    # enable completions for system packages
    pathsToLink = ["/share/zsh" "/share/nushell" "/share/fish" "/share/bash-completion" "/share/nix-direnv"];

    # https://github.com/NixOS/nixpkgs/issues/72394#issuecomment-549110501
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };
}
