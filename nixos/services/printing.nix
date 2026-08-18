{
  pkgs,
  ...
}:
with pkgs;
let
  # Brother's own driver, packaged from their .deb. The driverless IPP
  # Everywhere path only advertises 600x600 dpi, whereas this driver's PPD
  # exposes the hardware's real 600x2400 dpi mode.
  cups-brother-mfcl3740cdw = pkgs.callPackage ./printing/package.nix { };
in
{
  services = {
    printing = {
      enable = true;
      stateless = true;
      webInterface = false;
      # cups-browsed adds a second, DNS-SD-discovered queue for the same
      # printer, addressed by its .local name. That duplicate fails without
      # nss-mdns and only confuses the print dialog, so keep discovery off and
      # rely on the declarative queue below.
      browsed.enable = false;
      drivers = [
        cups-brother-mfcl3740cdw
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
      # Second queue on the same hardware, using Brother's native driver, so
      # its output can be compared side by side against the driverless queue
      # above. Brother's CUPS wrapper drives the printer over raw
      # AppSocket/JetDirect (port 9100) rather than IPP, and BRResolution
      # unlocks the 600x2400 dpi mode the IPP Everywhere PPD does not offer.
      {
        name = "Brother_MFC_L3740CDW_native";
        description = "Brother MFC-L3740CDW (native driver)";
        location = "Home";
        deviceUri = "socket://192.168.1.36:9100";
        model = "brother_mfcl3740cdw_printer_en.ppd";
        ppdOptions = {
          Duplex = "DuplexNoTumble";
          BRResolution = "600x2400dpi";
        };
      }
    ];
  };

  # brmfcl3740cdwfilter and brprintconf_mfcl3740cdw have
  # /opt/brother/Printers/<model>/inf/... baked into the binaries, and the
  # strings are too short to rewrite to a store path. Link the real prefix into
  # place so they can still find ImagingArea, PaperDimension and the rc files.
  systemd.tmpfiles.rules = [
    "d /opt/brother/Printers 0755 root root -"
    "L+ /opt/brother/Printers/mfcl3740cdw - - - - ${cups-brother-mfcl3740cdw}/opt/brother/Printers/mfcl3740cdw"
  ];

  # stateless CUPS wipes printers.conf on every start, and ensure-printers is a
  # oneshot with RemainAfterExit, so it does not re-run by itself. PartOf makes
  # systemd restart it whenever cups.service restarts, which re-adds the queue.
  systemd.services.ensure-printers.partOf = [ "cups.service" ];
}
