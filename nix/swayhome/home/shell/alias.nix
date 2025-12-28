{ ... }: let

  profile = import ./../../user/profile {};
  alias = import ./../../user/abbr {};

in {
  home-manager = {
    users.${profile.name} = {
      home = {
        shellAliases = alias.abbr;
      };
    };
  };
}
