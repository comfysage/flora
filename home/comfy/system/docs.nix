{ lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in
{
  programs.man.enable = true;

  # I don't use docs, so just disable them
  manual = mapAttrs (_: mkForce) {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
