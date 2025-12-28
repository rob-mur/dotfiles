{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        nix-index = {
          enable = false;
          enableFishIntegration = true;
        };
      };
    };
  };
}
