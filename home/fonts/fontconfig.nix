{config, ...}: let
in {
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
