{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nvidia.nix
    ./graphics.nix
    ./keyboard.nix
    ./platform.nix
    ./processor.nix
    ./sane.nix
  ];
}
