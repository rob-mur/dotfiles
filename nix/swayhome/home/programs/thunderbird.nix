{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        thunderbird= {
          enable = false;
          profiles = {
            "${profile.name}" = {
              isDefault = true;
              withExternalGnupg = true;
              search = {
                force = true;
                privateDefault = "ddg";
                default = "ddg";
              };
              settings = {
                "mail.spellcheck.inline" = false;
                "mailnews.database.global.views.global.columns" = {
                  selectCol = {
                    visible = false;
                    ordinal = 1;
                  };
                  threadCol = {
                    visible = true;
                    ordinal = 2;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
