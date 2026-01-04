{
  pkgs,
  enable_wayland_pkgs ? false,
  ...
}:
with pkgs;
let

  wayland_pkgs =
    if enable_wayland_pkgs then [
      swaybg
      swaykbdd
      wayland-utils
      waytrogen
      wl-clip-persist
      wl-clipboard
      wlprop
      wvkbd
    ]
    else
      [];
in {

  inherit wayland_pkgs;
}

