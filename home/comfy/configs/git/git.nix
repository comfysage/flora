{ pkgs, osConfig, ... }:
let
  cfg = osConfig.garden.programs.agnostic.git;
in
{
  programs.git = {
    enable = true;
    userName = "comfysage";
    userEmail = "comfysage" + "@" + "isabelroses" + "." + "com"; # obsfuscate email to prevent webscrapper spam

    extraConfig = {
      core = {
        editor = config.home.sessionVariables.EDITOR;
      };
      # QoL
      color.ui = "auto";
      diff.algorithm = "histogram"; # a much better diff
      safe.directory = "*";
      # add some must-use flags
      pull.rebase = true;
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_rsa.pub";
      # personal preference
      init.defaultBranch = "main";
      # prevent data corruption
      transfer.fsckObjects = true;
      fetch.fsckObjects = true;
      receive.fsckObjects = true;
      # better urls
      url = {
        "https://github.com/".insteadOf = "github:";
        "ssh://git@github.com/".pushInsteadOf = "github:";
        "https://gitlab.com/".insteadOf = "gitlab:";
        "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
        "https://aur.archlinux.org/".insteadOf = "aur:";
        "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
        "https://git.sr.ht/".insteadOf = "srht:";
        "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
        "https://codeberg.org/".insteadOf = "codeberg:";
        "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
      };
    };
  };
}
