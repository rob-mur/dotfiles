{
  pkgs,
  ...
}:
with pkgs;
{
  services = {
    printing = {
      enable = true;
      stateless = true;
      webInterface = false;
      drivers = [
        epson-escpr
        epson-escpr2
        foomatic-db
        gutenprint
        hplip
        splix
      ];
    };
  };

  # Declaratively define the printer so it survives stateless CUPS rebuilds.
  # Brother MFC-L3740CDW — driverless (IPP Everywhere / AirPrint), so no
  # vendor driver is needed. Addressed by IP rather than its mDNS .local name
  # because ensure-printers.service runs in a context without nss-mdns, so
  # .local resolution fails there. Give the printer a static DHCP lease on the
  # router (MAC dc:56:7b:b4:6a:0d) so this address stays valid.
  hardware.printers = {
    ensureDefaultPrinter = "Brother_MFC_L3740CDW";
    ensurePrinters = [
      {
        name = "Brother_MFC_L3740CDW";
        description = "Brother MFC-L3740CDW";
        location = "Home";
        deviceUri = "ipp://192.168.1.36/ipp/print";
        model = "everywhere";
        ppdOptions = {
          # Default to duplex, long-edge binding.
          Duplex = "DuplexNoTumble";
        };
      }
    ];
  };
}
