{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
    };
  };
}
