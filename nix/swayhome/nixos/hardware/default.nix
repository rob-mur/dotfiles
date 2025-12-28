{
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nvidia.nix
    ./graphics.nix
    ./keyboard.nix
    ./partition.nix
    ./platform.nix
    ./processor.nix
    ./sane.nix
    ./swapdevices.nix
  ];
}
