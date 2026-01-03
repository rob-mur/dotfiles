{config, ...}: let
in {
  programs = {
        pandoc = {
          enable = true;
          defaults = {
            metadata = {
              author = "${config.fullname}";
            };
            pdf-engine = "xelatex";
            citeproc = true;
      };
    };
  };
}
