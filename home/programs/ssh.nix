{config, ...}: let
in {
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = let
        sshdir = "${config.home.homeDirectory}/.ssh";
        sharedconfig = {
          AddKeysToAgent = "yes";
          ForwardAgent = true;
          IdentitiesOnly = true;
          IdentityFile = "${sshdir}/id_ed25519";
          User = "git";
        };
      in {
        "git.sr.ht" = sharedconfig;
        "github.com" = sharedconfig;
        "gitlab.com" = sharedconfig;
        "forgejo.clarob.uk" = sharedconfig // {
          User = "forgejo";
          Port = 2222;
        };
      };
    };
  };
}
