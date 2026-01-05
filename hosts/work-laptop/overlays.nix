{nixgl}: final: prev: let
  # Use nixGLIntel by default (most common for work laptops)
  # Can be changed to nixgl.nixGLNvidia or nixgl.nixGLMesa if needed
  nixGLWrapper = nixgl.packages.x86_64-linux.nixGLIntel;

  # Helper function to wrap a package with nixGL
  # This creates wrapper scripts that call nixGLIntel before the actual binary
  # and preserves the original package's override attributes for home-manager compatibility
  wrapWithNixGL = pkg:
    prev.lib.makeOverridable (args: let
      # Allow the base package to be overridden with args
      basePkg =
        if args != {}
        then pkg.override args
        else pkg;

      wrapped = prev.runCommand "${basePkg.name}-nixgl" {} ''
                mkdir -p $out/bin

                # For each binary in the package, create a wrapper
                for bin in ${basePkg}/bin/*; do
                  if [ -x "$bin" ]; then
                    binary_name=$(basename $bin)
                    cat > $out/bin/$binary_name <<EOF
        #!/bin/sh
        # Preserve XDG_DATA_DIRS for icon themes and other XDG data
        export XDG_DATA_DIRS="\''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
        exec ${nixGLWrapper}/bin/nixGLIntel ${basePkg}/bin/$binary_name "\$@"
        EOF
                    chmod +x $out/bin/$binary_name
                  fi
                done

                # Symlink other outputs (share for desktop files, icons, etc.)
                for dir in share lib include etc; do
                  if [ -d "${basePkg}/$dir" ]; then
                    ln -s "${basePkg}/$dir" "$out/$dir"
                  fi
                done
      '';
    in
      wrapped
      // {
        passthru =
          (basePkg.passthru or {})
          // {
            unwrapped = basePkg;
          };
      })
    {};
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

  # Use system swaylock for PAM compatibility on Ubuntu
  swaylock =
    prev.runCommand "swaylock-system-wrapper" {
      # Preserve the passthru attributes that home-manager expects
      passthru = {
        # This makes home-manager think the package is installed
        # but we're actually using the system binary
      };
    } ''
          mkdir -p $out/bin
          # Create a wrapper that calls the system swaylock
          cat > $out/bin/swaylock <<'EOF'
      #!/bin/sh
      # Use system swaylock for PAM compatibility
      exec /usr/bin/swaylock "$@"
      EOF
          chmod +x $out/bin/swaylock
    '';

  swayimg = wrapWithNixGL prev.swayimg;

  # PDF/document viewers
  zathura = wrapWithNixGL prev.zathura;
  sioyek = wrapWithNixGL prev.sioyek;
}
