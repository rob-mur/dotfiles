{ ... }: {
  systemd = {
    oomd = {
      enable = false; # Switch to earlyoom.
    };
    tpm2 = {
      enable = false;
    };
  };
}
