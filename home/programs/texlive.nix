{config, ...}: let
in {
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
}
