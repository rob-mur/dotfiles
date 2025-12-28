{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        bat = {
          enable = false;
          config = {
            italic-text = "always";
            paging = "always";
            tabs = "2";
          };
        };
      };
    };
  };
}
