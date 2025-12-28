{ ... }: {
  services = {
   open-webui = {
      enable = false;
      openFirewall = true;
    };
  };
}
