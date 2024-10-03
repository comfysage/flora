{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.hardware) ldTernary;
  inherit (lib.validators) ifTheyExist;
in
{
  users.users.comfy =
    {
      openssh.authorizedKeys.keys = [ ];

      home = "/${ldTernary pkgs "home" "Users"}/comfy";
      shell = pkgs.fish;
    }
    // (ldTernary pkgs {
      isNormalUser = true;
      uid = 1000;
      initialPassword = "changeme";

      # only add groups that exist
      extraGroups =
        [
          "wheel"
          "nix"
        ]
        ++ ifTheyExist config [
          "network"
          "networkmanager"
          "systemd-journal"
          "audio"
          "pipewire" # this give us access to the rt limits
          "video"
          "input"
          "plugdev"
          "lp"
          "tss"
          "power"
          "wireshark"
          "mysql"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "cloudflared"
        ];
    } { });
}
