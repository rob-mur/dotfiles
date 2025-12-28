{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      accounts.email = {
        maildirBasePath = "mail";
        accounts = {
          ${profile.email} = {
            primary = true;
            address = "${profile.email}";
            userName = "${profile.name}";
            realName = "${profile.fullname}";
            passwordCommand = "${pass}/bin/pass show disroot/main/${profile.name}";
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
              patterns = [ "*" ];
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
