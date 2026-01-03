{config, ...}: let
  alias = import ./../../user/abbr {inherit config;};
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = alias.abbr;
        };
      };
    };
  };
}
