{config, ...}: let
  alias = import ./../../user/abbr {inherit config;};
in {
  home-manager = {
    users.${config.name} = {
      home = {
        shellAliases = alias.abbr;
      };
    };
  };
}
