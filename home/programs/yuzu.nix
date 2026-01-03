{
  inputs,
  config,
  system,
  ...
}: let
  yuzu_pkgs = import inputs.yuzu-nixpkgs {system = "x86_64-linux";};
in {
  home-manager = {
    users.${config.name}.home.packages = [yuzu_pkgs.yuzu];
  };
}
