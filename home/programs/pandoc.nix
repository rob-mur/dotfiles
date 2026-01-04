{config, osConfig ? config, ...}: let
in {
  programs = {
        pandoc = {
          enable = true;
          defaults = {
            metadata = {
              author = "${osConfig.fullname}";
            };
            pdf-engine = "xelatex";
            citeproc = true;
      };
    };
  };
}
