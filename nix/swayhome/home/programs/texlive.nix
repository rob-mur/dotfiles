{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        texlive = {
          enable = true;
            extraPackages = tpkgs: {
            inherit (tpkgs)
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
