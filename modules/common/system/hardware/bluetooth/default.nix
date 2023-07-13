{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkIf (sys.bluetooth.enable) {
    modules.system.boot.extraKernelParams = ["btusb"];
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      #hsphfpd.enable = true;
      powerOnBoot = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    # https://nixos.wiki/wiki/Bluetooth
    services.blueman.enable = true;
  };
}
