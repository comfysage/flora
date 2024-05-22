{
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  inherit (pkgs) plymouth;
  inherit (lib) mkIf;

  cfg = config.modules.system.boot.plymouth;
in
{
  config = mkIf cfg.enable {
    boot.plymouth =
      {
        enable = true;
      }
      // lib.optionalAttrs cfg.withThemes {
        theme = "catppuccin-mocha";
        themePackages = [ inputs'.beapkgs.packages.plymouth-theme-catppuccin ];
      };

    # make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };
  };
}
