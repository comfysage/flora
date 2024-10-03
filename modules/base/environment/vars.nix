{ config, ... }:
let
  cfg = config.garden.programs.defaults;
in {
  # variables that I want to set globally on all systems
  environment.variables = {
    EDITOR = cfg.editor;
    VISUAL = cfg.editor;
    SUDO_EDITOR = cfg.editor;

    SYSTEMD_PAGERSECURE = "true";
    PAGER = cfg.pager_str;
    MANPAGER = cfg.manpager_str;

    # Some programs like `nh` use the FLAKE env var to determine the flake path
    FLAKE = config.garden.environment.flakePath;
  };
}
