{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
      services = {
        ssh-agent = {
          enable = true;
        };
      };
    };
  };
}
