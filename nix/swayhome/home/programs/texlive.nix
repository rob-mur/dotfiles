{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        texlive = {
          enable = true;
          extraPackages = tpkgs: {
            inherit
              (tpkgs)
              scheme-medium
              algorithms
              fontawesome5
              framed
              latexmk
              multirow
              pdfcol
              tcolorbox
              tikzfill
              ;
          };
        };
      };
    };
  };
}
