{ ... }: {
  networking = {
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        20 21 # ftp
        22 # ssh
        80 # http
        443 # https
        3000 # adguard
        8384 22000 # syncthing
        18080 18081 # monero
      ];
      allowedUDPPorts = [
        22000 21027  # syncthing
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # kdeconnect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # kdeconnect
      ];
      connectionTrackingModules = [
        "amanda"
        "ftp"
        "h323"
        "irc"
        "netbios_sn"
        "pptp"
        "sane"
        "sip"
        "snmp"
        "tftp"
      ];
    };
  };
}
