{ osConfig, ... }:
let
  cfg = osConfig.garden.programs.agnostic.git;
in
{
  programs.git = {
    enable = true;
    userName = "isabel";
    userEmail = "comfy" + "@" + "isabelroses" + "." + "com"; # obsfuscate email to prevent webscrapper spam

    # git commit signing
    signing = {
      key = cfg.signingKey;
      signByDefault = true;
    };

    extraConfig = {
      core.editor = osConfig.garden.programs.defaults.editor;

      # Qol
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
    };
  };
}
