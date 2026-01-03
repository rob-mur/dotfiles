{
  pkgs,
  ...
}:
with pkgs;
let

  theme = import ./../../user/theme {};

in {
  fonts = {
    enableDefaultPackages = true;
    packages = [
      alegreya
      alegreya-sans
      alice
      amiri
      caladea
      cantarell-fonts
      carlito
      comfortaa
      eunomia
      f1_8
      fa_1
      ferrum
      fira
      fira-code
      fira-mono
      fira-sans
      font-awesome
      hackgen-font
      ibm-plex
      inconsolata
      inriafonts
      inter
      iosevka
      jetbrains-mono
      jost
      lato
      liberation-sans-narrow
      liberation_ttf
      libertinus
      material-icons
      medio
      melete
      mona-sans
      mononoki
      montserrat
      nacelle
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      overpass
      pecita
      penna
      raleway
      recursive
      roboto
      roboto-mono
      roboto-serif
      roboto-slab
      route159
      seshat
      source-code-pro
      source-sans
      source-sans-pro
      source-serif
      source-serif-pro
      tenderness
      twitter-color-emoji
      unicode-emoji
      vegur
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["${theme.font-mono}" "${theme.font-mono-alt}"];
        serif = ["${theme.font-serif}" "${theme.font-serif-alt}"];
        sansSerif = ["${theme.font}" "${theme.font-alt}"];
        emoji = ["${theme.font-emoji}"];
      };
    };
  };
}
