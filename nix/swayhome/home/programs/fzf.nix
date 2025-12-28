{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
  };
}
