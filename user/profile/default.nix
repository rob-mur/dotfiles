{config, ...}: {
  imports = [
    ./profiles/desktop.nix
    # ./profiles/laptop_perso.nix
  ];

  name = config.name;
}
