{config, osConfig ? config, ...}: let
  alias = import ./../../user/abbr {config = osConfig;};
in {
  programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          shellAliases = alias.abbr;
    };
  };
}
