{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  inherit (config.garden.system) mainUser;
  homeDir = config.home-manager.users.${mainUser}.home.homeDirectory;
  sshDir = homeDir + "/.ssh";
in
{
  imports = [ inputs.agenix.nixosModules.default ];

  age = {
    # check the main users ssh key and the system key to see if it is safe
    # to decrypt the secrets
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "${sshDir}/id_ed25519"
    ];

    secretsDir = mkIf isDarwin "/private/tmp/agenix";
    secretsMountPoint = mkIf isDarwin "/private/tmp/agenix.d";

    secrets = { };
  };
}
