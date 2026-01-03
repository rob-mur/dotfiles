{config, ...}: let
  alias = import ./../../user/abbr {inherit config;};
in {
  programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = alias.abbr;
    };
  };
}
