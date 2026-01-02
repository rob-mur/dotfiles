{config, ...}: let
in {
  i18n = {
    defaultLocale = "${config.locale}";
    extraLocaleSettings = {
      LANGUAGE = "${config.locale}";
    };
  };
}
