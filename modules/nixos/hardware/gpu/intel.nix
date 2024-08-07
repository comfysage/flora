{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.garden) device;
in
{
  config = mkIf (device.gpu == "intel" || device.gpu == "hybrid-nv") {
    # i915 kernel module
    boot.initrd.kernelModules = [ "i915" ];
    # we enable modesetting since this is recomeneded for intel gpus
    services.xserver.videoDrivers = [ "modesetting" ];

    # OpenCL support and VAAPI
    hardware.graphics = {
      extraPackages = builtins.attrValues {
        inherit (pkgs) libva-vdpau-driver intel-media-driver;

        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };

      extraPackages32 = builtins.attrValues {
        inherit (pkgs.pkgsi686Linux) libva-vdpau-driver intel-media-driver;

        intel-vaapi-driver = pkgs.pkgsi686Linux.intel-vaapi-driver.override { enableHybridCodec = true; };
      };
    };

    environment.systemPackages = [ pkgs.intel-gpu-tools ];

    environment.variables = mkIf (config.hardware.graphics.enable && device.gpu != "hybrid-nv") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
