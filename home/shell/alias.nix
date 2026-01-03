{config, ...}: let
  alias = import ./../../user/abbr {inherit config;};
in {
  home = {
        shellAliases = alias.abbr;
  };
}
