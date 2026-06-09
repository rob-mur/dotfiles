{...}: {
  programs.firefox.enable = true;
  # 26.05 moved the default profile dir under XDG_CONFIG_HOME; keep the
  # existing ~/.mozilla/firefox profile to avoid migrating data.
  programs.firefox.configPath = ".mozilla/firefox";
}
