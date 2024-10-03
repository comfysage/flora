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
  config = mkIf osConfig.garden.programs.tui.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # wishlist # fancy ssh
        glow # fancy markdown
        # fx # fancy jq
        gum # a nicer scripting
        ;
    };
  };
}
