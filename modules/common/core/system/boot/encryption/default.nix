{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system.boot.encryption;
in {
  config = mkIf cfg.enable {
    # improve performance for disk encryption
    boot.initrd.availableKernelModules = [
      "aesni_intel"
      "cryptd"
      "usb_storage"
    ];

    services.lvm.enable = true;

    # TODO: account for multiple encrypted devices
    boot.initrd.luks.devices."${cfg.device}" = {
      # improve performance on ssds
      bypassWorkqueues = true;
      preLVM = true;

      # the device with the maching id will be searched for the key file
      keyFile = mkIf (cfg.keyFile != null) "${cfg.keyFile}";
      keyFileSize = cfg.keySize;

      # if keyfile is not there, fall back to cryptsetup password
      inherit (cfg) fallbackToPassword; # IMPLIED BY config.boot.initrd.systemd.enable
    };
  };
}
