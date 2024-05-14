{
  lib,
  inputs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf isModernShell;
in
{
  imports = [ inputs.izrss.homeManagerModules.default ];

  config = mkIf (isModernShell osConfig) {
    programs.izrss = {
      enable = true;

      urls = [
        "https://isabelroses.com/feed.xml"
        "https://uncenter.dev/feed.xml"
        "https://charm.sh/blog/rss.xml"
        "https://antfu.me/feed.xml"
        "https://fasterthanli.me/index.xml"
        "https://blog.orhun.dev/rss.xml"
        "https://mitchellh.com/feed.xml"
        "https://dataswamp.org/~solene/rss-html.xml"
        "https://ayats.org/index.xml"
        "https://nixpkgs.news/rss.xml"
        "https://maia.crimew.gay/feed.xml"
      ];
    };
  };
}
