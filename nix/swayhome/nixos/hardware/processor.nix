{
  config,
  lib,
  ...
}: {
  hardware = {
    cpu = {
      # Amd or Intel
      intel = {
        updateMicrocode =
         lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };
}
