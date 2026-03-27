{pkgs, ...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # required for KMS capture
    openFirewall = true;
    # AT_SECURE=1 is set by the capSysAdmin wrapper → LD_LIBRARY_PATH is ignored.
    # Bake /run/opengl-driver/lib into the ELF RPATH so libcuda.so.1 is found.
    # runCommand just copies + patches the pre-built binary; no source rebuild needed.
    package =
      let
        patchedBin = pkgs.runCommand "sunshine-cuda-rpath" {
          nativeBuildInputs = [ pkgs.patchelf ];
        } ''
          mkdir -p $out/bin
          cp ${pkgs.sunshine}/bin/sunshine $out/bin/sunshine
          chmod +w $out/bin/sunshine
          patchelf --add-rpath /run/opengl-driver/lib $out/bin/sunshine
        '';
      in
      (pkgs.symlinkJoin {
        name = "sunshine-cuda";
        paths = [ patchedBin pkgs.sunshine ];
      }) // { meta = pkgs.sunshine.meta // { mainProgram = "sunshine"; }; };
    settings = {
      capture = "kms"; # use KMS/DRM direct capture → DMA-buf → CUDA → NVENC (zero-copy)
      sw_preset = "superfast"; # faster encode = less buffering/latency
      sw_tune = "zerolatency"; # disables B-frames and lookahead for lowest encode latency
      fec_percentage = 5; # minimal error correction overhead on LAN
    };
    applications = {
      env.PATH = "$(PATH):$(HOME)/.local/bin";
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Yuzu";
          cmd = "env QT_QPA_PLATFORM=wayland yuzu";
          image-path = "steam.png";
        }
      ];
    };
  };

  systemd.user.services.sunshine.environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib"; # libcuda.so.1 for NVENC (works without file caps)
  systemd.user.services.sunshine.environment.LIBVA_DRIVER_NAME = "iHD"; # Intel VAAPI fallback if NVENC fails

  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660"
  '';
}
