{
  pkgs,
  config,
  lib,
  osConfig ? config,
  ...
}: {
  home.packages = lib.optional osConfig.enableSteam pkgs.steam;
}
