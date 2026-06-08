{...}: {
  programs.firefox.enable = true;
  # 26.05 moved the default profile dir under XDG_CONFIG_HOME; keep the
  # existing ~/.mozilla/firefox profile to avoid migrating data.
  programs.firefox.configPath = ".mozilla/firefox";

  # Force XWayland for Firefox: Wayland popup compositing path crashes on
  # NVIDIA + wlroots (broken pipe on notification doorhanger).
  # Re-evaluate when nvidia/wlroots explicit-sync issues are resolved upstream.
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
