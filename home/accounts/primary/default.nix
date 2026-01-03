{
  pkgs,
  config,
  ...
}:
with pkgs; let
in {
  accounts.email = {
        maildirBasePath = "mail";
        accounts = {
          ${config.email} = {
            primary = true;
            address = "${config.email}";
            userName = "${config.name}";
            realName = "${config.fullname}";
            passwordCommand = "${pass}/bin/pass show disroot/main/${config.name}";
            flavor = "plain";
            imap = {
              host = "disroot.org";
              port = 993;
              tls = {
                enable = true;
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
    };
  };
}
