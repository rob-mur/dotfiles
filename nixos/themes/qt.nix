{ ... }: {
  qt = {
    enable = true;
    # "kde" is the only value that themes Qt5 *and* Qt6 from one env var.
    # "qt5ct" exports QT_QPA_PLATFORMTHEME=qt5ct verbatim, and there is no
    # qt5ct plugin for Qt6 — so Qt6 apps (dolphin, ark, ...) silently loaded
    # no platform theme and fell back to Qt's default *light* palette, while
    # QT_STYLE_OVERRIDE=breeze still supplied dark text. Hence white-on-white
    # file names in dolphin. The KDE theme reads ~/.config/kdeglobals, which
    # home/config/qt keeps pinned to BreezeDark.
    platformTheme = "kde";
  };
}
