{ ... }: {
  # Record per-process and per-cgroup memory, so `below replay` names the
  # process behind the next out-of-memory lockup.
  services.below.enable = true;
}
