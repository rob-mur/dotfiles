{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        bottom = {
          enable = true;
          settings = {
            flags = {
              avg_cpu = true;
              temperature_type = "c";
            };
            colors = {
              low_battery_color = "red";
            };
          };
        };
      };
    };
  };
}
