{nixgl}: final: prev: let
  # Use nixGLIntel by default (most common for work laptops)
  # Can be changed to nixgl.nixGLNvidia or nixgl.nixGLMesa if needed
  nixGLWrapper = nixgl.packages.x86_64-linux.nixGLIntel;

  # Helper function to wrap a package with nixGL
  # This creates wrapper scripts that call nixGLIntel before the actual binary
  # and preserves the original package's override attributes for home-manager compatibility
  wrapWithNixGL = {pkg, extraFlags ? ""}:
    prev.lib.makeOverridable (args: let
      # Handle potential overrides like pkg.override { ... }
      basePkg =
        if args != {}
        then pkg.override args
        else pkg;

      # Determine the name for the new derivation
      name = "${basePkg.pname or basePkg.name}-nixgl";
    in
      prev.runCommand name {
        nativeBuildInputs = [prev.makeWrapper prev.gnused];
      } ''
        mkdir -p $out/bin

        # 1. Wrap every executable found in the original package's bin folder
        if [ -d "${basePkg}/bin" ]; then
          for bin in ${basePkg}/bin/*; do
            if [ -x "$bin" ]; then
              binary_name=$(basename "$bin")
              makeWrapper "${nixGLWrapper}/bin/nixGLIntel" "$out/bin/$binary_name" \
                --argv0 "$binary_name" \
                --add-flags "$bin ${extraFlags}" \
                --prefix XDG_DATA_DIRS : "$out/share"
            fi
          done
        fi

        # 2. Patch ALL desktop files in the package to point to our new wrappers
        if [ -d "${basePkg}/share" ]; then
          mkdir -p $out/share
          # Copy share contents (icons, desktop files, etc.) so we can modify them
          cp -aL ${basePkg}/share/* $out/share/
          chmod -R +w $out/share/

          if [ -d "$out/share/applications" ]; then
            for desktop_file in $out/share/applications/*.desktop; do
              if [ -f "$desktop_file" ]; then
                echo "Processing desktop file: $desktop_file"
                # Extract executable from Exec line, ignoring arguments
                exec_line=$(grep -E '^Exec=' "$desktop_file" | head -n 1)
                original_exec=$(echo "$exec_line" | cut -d'=' -f2- | cut -d' ' -f1)
                original_binary=$(basename "$original_exec")

                # Check if we have a wrapped version of this binary
                if [ -f "$out/bin/$original_binary" ]; then
                  echo "Found wrapped binary for $original_binary, patching..."
                  # Use sed to replace the executable path, preserving arguments
                  sed -i "s|Exec=$original_exec|Exec=$out/bin/$original_binary|g" "$desktop_file"
                  sed -i "s|Exec=$original_binary|Exec=$out/bin/$original_binary|g" "$desktop_file"
                else
                  echo "No wrapped binary found for $original_binary"
                fi
              fi
            done
          fi
        fi

        # 3. Symlink everything else (lib, include, etc.)
        for dir in lib include etc; do
          if [ -d "${basePkg}/$dir" ]; then
            ln -s "${basePkg}/$dir" "$out/$dir"
          fi
        done
      ''
      // {
        # Preserve metadata so Home Manager knows what this is
        meta = basePkg.meta // {outputsToInstall = ["out"];};
        passthru = (basePkg.passthru or {}) // {unwrapped = basePkg;};
      }) {};
in {
  # Terminal emulators (high priority - these definitely need GPU)
  kitty = wrapWithNixGL {pkg = prev.kitty;};
  alacritty = wrapWithNixGL {pkg = prev.alacritty;};
  foot = wrapWithNixGL {pkg = prev.foot;};

  # Browsers (need GPU acceleration)
  vivaldi = wrapWithNixGL {pkg = prev.vivaldi;};
  firefox = wrapWithNixGL {pkg = prev.firefox;};

  # Media players and viewers
  mpv = wrapWithNixGL {pkg = prev.mpv;};
  imv = wrapWithNixGL {pkg = prev.imv;};

  # Wayland tools (need GPU for rendering)
  waybar = wrapWithNixGL {pkg = prev.waybar;};
  wofi = wrapWithNixGL {pkg = prev.wofi;};
  rofi-wayland = wrapWithNixGL {pkg = prev.rofi-wayland;};

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

  swayimg = wrapWithNixGL {pkg = prev.swayimg;};

  # PDF/document viewers
  zathura = wrapWithNixGL {pkg = prev.zathura;};
  sioyek = wrapWithNixGL {pkg = prev.sioyek;};

  # Slack (needs gpu as it's a browser)
  slack = wrapWithNixGL {pkg = prev.slack;};
}
