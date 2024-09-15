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
  config = mkIf osConfig.garden.programs.gui.discord.enable {
    home.packages = mkIf pkgs.stdenv.isLinux [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
