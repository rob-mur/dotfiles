{config, ...}: let
  alias = import ./../../user/abbr {inherit config;};
in {
  home-manager = {
    users.${config.name} = {
      programs = {
        nushell = {
          enable = false;
          shellAliases = alias.abbr;
          extraConfig = ''
            $env.config.show_banner = false
            $env.config.table.mode = 'compact'
          '';
        };
      };
    };
  };
}
