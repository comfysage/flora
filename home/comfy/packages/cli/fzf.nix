{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;
  inherit (lib.validators) isModernShell;
  inherit (lib) mapAttrsToList;

  default = {
    margin = "0,2";
    padding = "1";
    height = "16";
    layout = "reverse-list";
    info = "right";
    preview-window = "border-rounded";
    prompt = "> ";
    marker = ">";
    pointer = "◆";
    separator = "─";
    scrollbar = "│";
  };
  find = {
    files = "${getExe pkgs.fd} --type=f --hidden --exclude=.git";
    dirs = "${getExe pkgs.fd} --type=d --hidden --exclude=.git";
  };
  preview = {
    file = "--preview 'head {}'";
    dir = "--preview 'tree -C {} | head -200'";
  };
in
{
  programs.fzf = mkIf (isModernShell osConfig) {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;

    defaultCommand = find.files;
    defaultOptions = mapAttrsToList (n: v: "--${n}='${v}'") default;
    fileWidgetCommand = find.files;
    fileWidgetOptions = [ preview.file ];
    changeDirWidgetCommand = find.dirs;
    changeDirWidgetOptions = [ preview.dir ];
  };
}
