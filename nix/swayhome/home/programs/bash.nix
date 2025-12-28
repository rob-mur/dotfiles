{ ... }: let

  profile = import ./../../user/profile {};
  alias = import ./../../user/abbr {};

in {
  home-manager = {
    users.${profile.name} = {
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
