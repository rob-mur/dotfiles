{config, osConfig ? config, ...}: let
  alias = import ./../../user/abbr {config = osConfig;};
in {
  home = {
        shellAliases = alias.abbr;
  };
}
