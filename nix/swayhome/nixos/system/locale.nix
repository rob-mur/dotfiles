{ ... }: let

  profile = import ./../../user/profile {};

in {
  i18n = {
    defaultLocale = "${profile.defaultlocale}";
    extraLocaleSettings = {
      LANGUAGE = "${profile.defaultlocale}";
    };
  };
}
