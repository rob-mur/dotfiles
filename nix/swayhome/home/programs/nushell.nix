{ ... }: let

  profile = import ./../../user/profile {};
  alias = import ./../../user/abbr {};

in {
  home-manager = {
    users.${profile.name} = {
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
