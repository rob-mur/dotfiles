{
  pkgs,
  lib,
  ...
}: let
  vocab = import ./vocab.nix {inherit lib;};

  # Fetched declaratively so the service never needs `voxtype setup`.
  model = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin";
    hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
  };

  toml = pkgs.formats.toml {};
in {
  # Local dictation. Vulkan build for the RTX 3070 Ti (no CUDA build needed);
  # taken from unstable because stable only has 0.7.2 without a GPU variant.
  # wtype is the Wayland typing backend; voxtype falls back to ydotool
  # (already enabled system-wide) then the clipboard.
  home.packages = [pkgs.pkgs-unstable.voxtype-vulkan pkgs.wtype];

  xdg.configFile."voxtype/config.toml".source = toml.generate "voxtype-config.toml" {
    state_file = "auto";

    # Hold-to-talk comes from sway (bindsym below); the evdev hotkey stays off.
    hotkey.enabled = false;

    # "default" follows the system default source, i.e. the raw mic. The
    # RNNoise "Noise Canceled Mic" from services/mic-denoise.nix is not used:
    # Whisper is trained on noisy audio and RNNoise's gating clips word onsets
    # and adds artifacts, which hurts accuracy more than hiss does. That chain
    # is also tuned for the laptop's internal mic.
    audio = {
      device = "default";
      sample_rate = 16000;
      max_duration_secs = 120;
    };

    whisper = {
      model = "${model}";
      language = "en";
      initial_prompt = vocab.prompt;
    };

    output.mode = "type";

    text.replacements = vocab.replacements;
  };

  # Hold Super+V to dictate, release to transcribe and type.
  wayland.windowManager.sway.config.keybindings = {
    "--no-repeat Mod4+v" = "exec voxtype record start";
    "--release Mod4+v" = "exec voxtype record stop";
  };
}
