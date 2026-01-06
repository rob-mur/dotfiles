{
  config,
  system,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [yuzu-pkgs.yuzu];
}
