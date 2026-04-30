{...}: {
  programs.firefox.enable = true;

  # Force XWayland for Firefox: Wayland popup compositing path crashes on
  # NVIDIA + wlroots (broken pipe on notification doorhanger).
  # Re-evaluate when nvidia/wlroots explicit-sync issues are resolved upstream.
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";
}
