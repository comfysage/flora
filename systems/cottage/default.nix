{
  imports = [ ./hardware.nix ];

  garden = {
    device = {
      type = "hybrid";
      cpu = "amd";
      gpu = null;
      monitors = [ "eDP-1" ];
      hasTPM = true;
      hasBluetooth = true;
      hasSound = true;
    };

    system = {
      mainUser = "comfy";

      boot = {
        loader = "systemd-boot";
        secureBoot = true;
        tmpOnTmpfs = false;
        loadRecommendedModules = true;
        enableKernelTweaks = true;
        initrd.enableTweaks = true;
        plymouth.enable = false;
      };

      fs.support = [
        "btrfs"
        "vfat"
        "ext4"
        "ntfs"
      ];
      video.enable = true;
      sound.enable = true;
      bluetooth.enable = true;
      printing.enable = false;
      yubikeySupport.enable = false;

      security = {
        fixWebcam = false;
        auditd.enable = true;
      };

      networking = {
        optimizeTcp = true;
        wirelessBackend = "iwd";
      };

      virtualization = {
        enable = true;
        docker.enable = false;
        qemu.enable = false;
        podman.enable = false;
        distrobox.enable = false;
      };
    };

    environment = {
      desktop = "Hyprland";
      useHomeManager = true;
    };

    programs = {
      agnostic.git.signingKey = "7AFB9A49656E69F7";

      cli = {
        enable = true;
        modernShell.enable = true;
      };

      tui.enable = true;

      gui = {
        enable = true;

        kdeconnect = {
          enable = false;
          indicator.enable = true;
        };

        bars.ags.enable = false;

        bars.waybar.enable = true;

        terminals.kitty.enable = true;

        zathura.enable = true;
      };

      gaming.enable = false;
    };

    services.cloudflared.enable = true;
  };
}
