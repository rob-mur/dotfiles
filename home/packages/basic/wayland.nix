{pkgs, ...}:
with pkgs; {
  home.packages = [
    swaybg
    swaykbdd
    wayland-utils
    waytrogen
    wl-clip-persist
    wl-clipboard
    wlprop
    wvkbd
  ];
}
