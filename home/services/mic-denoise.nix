{
  pkgs,
  ...
}: let
  # The internal HDA mic has a high analog noise floor. We keep the analog
  # capture gain modest (Boost 0, Capture ~65%) and run an RNNoise LADSPA
  # filter in a PipeWire filter-chain, exposing a clean "rnnoise_source"
  # virtual mic that apps (browsers, Slack, Zoom) can select.
  #
  # This host runs the *system* (Ubuntu) PipeWire, not a nix one, so it
  # dlopens the plugin into a process linked against the system glibc.
  # The stock nixpkgs plugin carries a RUNPATH to nix's own glibc/libstdc++,
  # which makes that dlopen fail ("No such file or directory"). Stripping the
  # RUNPATH lets the loader resolve the plugin's deps (libc, libstdc++,
  # libatomic) against the host's system libraries instead. The plugin only
  # needs GLIBCXX_3.4, which the system libstdc++ provides.
  rnnoiseLadspa =
    pkgs.runCommand "rnnoise-ladspa-system" {
      nativeBuildInputs = [pkgs.patchelf];
    } ''
      mkdir -p $out/lib/ladspa
      cp ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so $out/lib/ladspa/
      chmod u+w $out/lib/ladspa/librnnoise_ladspa.so
      patchelf --remove-rpath $out/lib/ladspa/librnnoise_ladspa.so
    '';
  pluginPath = "${rnnoiseLadspa}/lib/ladspa/librnnoise_ladspa.so";
in {
  # PipeWire filter-chain: internal mic -> RNNoise -> "Noise Canceled Mic".
  xdg.configFile."pipewire/pipewire.conf.d/99-mic-denoise.conf".text = ''
    context.modules = [
      { name = libpipewire-module-filter-chain
        flags = [ nofail ]
        args = {
          node.description = "Noise Canceled Mic"
          media.name       = "Noise Canceled Mic"
          filter.graph = {
            nodes = [
              {
                type   = ladspa
                name   = rnnoise
                plugin = "${pluginPath}"
                label  = noise_suppressor_mono
                control = {
                  "VAD Threshold (%)"          = 50.0
                  "VAD Grace Period (ms)"      = 200
                  "Retroactive VAD Grace (ms)" = 0
                }
              }
            ]
          }
          capture.props = {
            node.name    = "capture.rnnoise_source"
            node.passive = true
            audio.rate   = 48000
          }
          playback.props = {
            node.name        = "rnnoise_source"
            node.description = "Noise Canceled Mic"
            media.class      = Audio/Source
            audio.rate       = 48000
          }
        }
      }
    ]
  '';

  # Pin clean analog capture levels at login. High mic boost + full capture
  # gain (the vendor default: +30dB boost, +30dB capture) is what produced
  # the static; RNNoise handles residual hiss at these lower levels.
  systemd.user.services.mic-analog-levels = {
    Unit = {
      Description = "Set clean analog capture levels for the internal mic";
      After = ["wireplumber.service"];
      Wants = ["wireplumber.service"];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mic-analog-levels" ''
        ${pkgs.alsa-utils}/bin/amixer -c 0 sset 'Internal Mic Boost' 0
        ${pkgs.alsa-utils}/bin/amixer -c 0 sset 'Capture' 65%
      '';
    };
    Install.WantedBy = ["default.target"];
  };
}
