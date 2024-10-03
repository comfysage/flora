{ lib, config, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum nullOr str;

  pagers = [
    "less" # -FR
    "bat" # -l help --pager
    "nvim" # +Man!
  ];
in
{
  options.garden.programs.defaults = {
    terminal = mkOption {
      type = enum [
        "alacritty"
        "kitty"
        "wezterm"
        "foot"
      ];
      default = "wezterm";
    };

    fileManager = mkOption {
      type = enum [
        "cosmic-files"
        "thunar"
        "dolphin"
        "nemo"
      ];
      default = "cosmic-files";
    };

    browser = mkOption {
      type = enum [
        "firefox"
        "chromium"
        "thorium"
      ];
      default = "thorium";
    };

    editor = mkOption {
      type = enum [
        "nvim"
        "codium"
      ];
      default = "nvim";
    };

    pager = mkOption {
      type = enum pagers;
      default = "less";
    };
    manpager = mkOption {
      type = enum pagers;
      default = "less";
    };
    pagerArgs = mkOption {
      type = str;
      default = "-FR";
    };
    manpagerArgs = mkOption {
      type = str;
      default = "-FR";
    };
    pager_str = mkOption {
      type = str;
      default =
        let
          c = config.garden.programs.defaults;
        in
        "${c.pager} ${c.pagerArgs}";
      internal = true;
    };
    manpager_str = mkOption {
      type = str;
      default =
        let
          c = config.garden.programs.defaults;
        in
        "${c.manpager} ${c.manpagerArgs}";
      internal = true;
    };

    launcher = mkOption {
      type = nullOr (enum [
        "rofi"
        "wofi"
      ]);
      default = "rofi";
    };

    bar = mkOption {
      type = nullOr (enum [
        "waybar"
        "ags"
      ]);
      default = "ags";
    };

    screenLocker = mkOption {
      type = nullOr (enum [
        "swaylock"
        "gtklock"
      ]);
      default = "gtklock";
      description = ''
        The lockscreen module to be loaded by home-manager.
      '';
    };

    noiseSuppressor = mkOption {
      type = nullOr (enum [
        "rnnoise"
        "noisetorch"
      ]);
      default = "rnnoise";
      description = ''
        The noise suppressor to be used for desktop systems with sound enabled.
      '';
    };
  };
}
