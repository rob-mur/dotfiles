{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      services = {
        ssh-agent = {
          enable = true;
        };
      };
    };
  };
}
