{config, pkgs, ...}: let
in {
  # The terminal font is drawn by the client's kitty, never by the host at the
  # other end of ssh or inside a docker container. Shipping it from home
  # rather than nixos/system/fonts.nix means Ubuntu hosts (work-laptop) get it
  # too, so `theme.font-mono` resolves wherever kitty runs.
  home.packages = [pkgs.nerd-fonts.iosevka];

  fonts = {
        fontconfig = {
          enable = true;

          # LibreOffice draws document text unhinted, so print metrics stay
          # correct. Without subpixel rendering its glyph stems look blurry,
          # worst in Calc. Set here so Ubuntu hosts get it too, where
          # `nixos/system/fonts.nix` does not apply.
          antialiasing = true;
          hinting = "slight";
          subpixelRendering = "rgb";
    };
  };
}
