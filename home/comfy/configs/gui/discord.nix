{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  home.packages =
    mkIf (osConfig.garden.programs.gui.discord.enable && pkgs.stdenv.hostPlatform.isLinux)
      [
        (pkgs.discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
      ];
}
