{ lib, pkgs, ... }:
{
  users.users.root = lib.modules.mkIf pkgs.stdenv.hostPlatform.isLinux {
    initialPassword = "changeme";

    openssh.authorizedKeys.keys = [ ];
  };
}
