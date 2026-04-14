{ ... }: {
  programs = {
    ssh = {
      startAgent = false;
      enableAskPassword = true;
    };
  };
}
