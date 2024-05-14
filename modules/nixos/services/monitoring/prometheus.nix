{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.modules.services.monitoring.prometheus;
in
{
  config = mkIf cfg.enable {
    services = {
      # Prometheus exporter for Grafana
      prometheus = {
        enable = true;
        port = cfg.port;
        globalConfig = {
          scrape_interval = "10s";
          scrape_timeout = "2s";
        };

        # enabled exporters
        exporters = {
          node = {
            enable = true;
            port = 9101;
            enabledCollectors = [
              "logind"
              "processes"
              "systemd"
              "interrupts"
              "tcpstat"
            ];
          };

          redis = {
            enable = true;
            port = 9102;
            user = "redis";
          };

          postgres = {
            enable = true;
            port = 9103;
            user = "postgres";
          };

          nginx = {
            enable = true;
            port = 9104;
          };

          smartctl = {
            inherit (config.services.smartd) enable;
            openFirewall = config.services.smartd.enable;
            # Defaults:
            user = "smartctl-exporter";
            group = "disk";
            port = 9110;
          };
        };

        scrapeConfigs =
          let
            exp = config.services.prometheus.exporters;
          in
          [
            {
              job_name = "prometheus";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString config.services.prometheus.port}" ]; } ];
            }
            {
              job_name = "node";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString exp.node.port}" ]; } ];
            }
            {
              job_name = "redis";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString exp.redis.port}" ]; } ];
            }
            {
              job_name = "postgres";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString exp.postgres.port}" ]; } ];
            }
            {
              job_name = "nginx";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString exp.nginx.port}" ]; } ];
            }
            {
              job_name = "uptime-kuma";
              scrape_interval = "30s";
              scrape_timeout = "10s";
              metrics_path = "/metrics";
              static_configs = [ { targets = [ "${cfg.host}:3500" ]; } ];
            }
            {
              job_name = "smartctl";
              scrape_interval = "30s";
              static_configs = [ { targets = [ "${cfg.host}:${toString exp.smartctl.port}" ]; } ];
            }
          ];
      };
    };
  };
}
