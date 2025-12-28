{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        comodoro = {
          enable = false;
          settings = {
            ${profile.name} = {
              cycles = [
                {
                  name = "Work";
                  duration = 1500;
                }
                {
                  name = "Rest";
                  duration = 300;
                }
              ];

              tcp-host = "localhost";
              tcp-port = 1234;

              # # v0.1
              # tcp = {
              #   host = "localhost";
              #   port = 1234;
              # };

              # cycles-count = 5;
              # precision = "minute";

              on-server-start = "echo server started";
              on-timer-stop = "echo timer stopped";
              on-work-begin = "echo work cycle began";

              # # v0.1
              # hooks = {
              #   on-work-begin = {
              #     notify = {
              #       summary = "Comodoro";
              #       body = "Work started!";
              #     };
              #     command = "${notify-desktop}/bin/notify-desktop 'Comodoro' 'Work started!'";
              #   };
              # };
            };
          };
        };
      };
      services = {
        comodoro = {
          enable = false;
          protocols = [ "tcp" ];
          preset = "${profile.name}";
        };
      };
    };
  };
}
