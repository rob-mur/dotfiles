{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = { config, ... }: {
      programs = {
        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = let
            sshdir = "${config.home.homeDirectory}/.ssh";
            sharedconfig = {
              addKeysToAgent = "yes";
              forwardAgent = true;
              identitiesOnly = true;
              identityFile = "${sshdir}/id_ed25519";
              user = "git";
            };
          in {
            "git.sr.ht" = sharedconfig;
            "github.com" = sharedconfig;
            "gitlab.com" = sharedconfig;
          };
        };
      };
    };
  };
}
