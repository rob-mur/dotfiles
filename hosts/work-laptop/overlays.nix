{nixgl}: final: prev: let
  # Use nixGLIntel by default (most common for work laptops)
  # Can be changed to nixgl.nixGLNvidia or nixgl.nixGLMesa if needed
  nixGLWrapper = nixgl.packages.x86_64-linux.nixGLIntel;

  # Helper function to wrap a package with nixGL
  # This creates wrapper scripts that call nixGLIntel before the actual binary
  # and preserves the original package's override attributes for home-manager compatibility
  wrapWithNixGL = pkg: let
    wrapped = prev.runCommand "${pkg.name}-nixgl" {} ''
      mkdir -p $out/bin

      # For each binary in the package, create a wrapper
      for bin in ${pkg}/bin/*; do
        if [ -x "$bin" ]; then
          binary_name=$(basename $bin)
          cat > $out/bin/$binary_name <<EOF
#!/bin/sh
exec ${nixGLWrapper}/bin/nixGLIntel ${pkg}/bin/$binary_name "\$@"
EOF
          chmod +x $out/bin/$binary_name
        fi
      done

      # Symlink other outputs (share for desktop files, icons, etc.)
      for dir in share lib include etc; do
        if [ -d "${pkg}/$dir" ]; then
          ln -s "${pkg}/$dir" "$out/$dir"
        fi
      done
    '';
  in
    wrapped // {
      # Preserve override for packages that home-manager needs to customize
      override = args: wrapWithNixGL (pkg.override args);
      overrideAttrs = f: wrapWithNixGL (pkg.overrideAttrs f);
      passthru = (pkg.passthru or {}) // {
        unwrapped = pkg;
      };
    };
in {
  # Terminal emulators (high priority - these definitely need GPU)
  kitty = wrapWithNixGL prev.kitty;
  alacritty = wrapWithNixGL prev.alacritty;
  foot = wrapWithNixGL prev.foot;

  # Browsers (need GPU acceleration)
  vivaldi = wrapWithNixGL prev.vivaldi;
  firefox = wrapWithNixGL prev.firefox;

  # Media players and viewers
  mpv = wrapWithNixGL prev.mpv;
  imv = wrapWithNixGL prev.imv;

  # Wayland tools (need GPU for rendering)
  waybar = wrapWithNixGL prev.waybar;
  wofi = wrapWithNixGL prev.wofi;
  rofi-wayland = wrapWithNixGL prev.rofi-wayland;
  swaylock = wrapWithNixGL prev.swaylock;
  swayimg = wrapWithNixGL prev.swayimg;

  # PDF/document viewers
  zathura = wrapWithNixGL prev.zathura;
  sioyek = wrapWithNixGL prev.sioyek;
}
