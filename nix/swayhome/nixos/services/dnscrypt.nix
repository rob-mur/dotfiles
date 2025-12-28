{ ... }: {
  services = {
    dnscrypt-proxy = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
      };
    };
  };
}
