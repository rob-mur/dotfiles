{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        pandoc = {
          enable = true;
          defaults = {
            metadata = {
              author = "${profile.fullname}";
            };
            pdf-engine = "xelatex";
            citeproc = true;
          };
        };
      };
    };
  };
}
