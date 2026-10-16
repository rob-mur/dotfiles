{ ... }: {
  services = {
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      # Kill the largest process, not the highest oom_score. User services
      # carry oom_score_adj 200, so by score earlyoom kills idle daemons
      # before a 10 GiB process in a terminal (lockups on 14 and 16 Oct).
      extraArgs = ["--sort-by-rss"];
    };
  };
}
