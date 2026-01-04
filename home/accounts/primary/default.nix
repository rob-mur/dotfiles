{
  pkgs,
  config,
  osConfig ? config,
  ...
}:
with pkgs; let
in {
  accounts.email = {
    maildirBasePath = "mail";
    accounts = {
      ${osConfig.email} = {
        primary = true;
        address = "${osConfig.email}";
        userName = "${osConfig.name}";
        realName = "${osConfig.fullname}";
        passwordCommand = "${pass}/bin/pass show disroot/main/${osConfig.name}";
        flavor = "plain";
        imap = {
          host = "disroot.org";
          port = 993;
          tls = {
            enable = true;
          };
        };
        smtp = {
          host = "disroot.org";
          port = 465; # 465 smtps, 587 smtp
          tls = {
            enable = true;
            useStartTls = false; # true for smtp
          };
        };

        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
          flatten = ".";
          patterns = ["*"];
        };
        msmtp = {
          enable = true;
        };
        neomutt = {
          enable = true;
        };
        folders = {
          inbox = "Inbox";
          sent = "Sent";
          drafts = "Drafts";
          trash = "Trash";
        };
      };
    };
  };
}
