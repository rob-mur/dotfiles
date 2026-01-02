{config, ...}: let
in {
  time.timeZone = "${config.timezone}";
}
