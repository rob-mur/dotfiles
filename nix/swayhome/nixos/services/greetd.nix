{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../user/profile {};

in {
  services = {
   greetd = {
      enable = false;
      settings = rec {
        initial_session = {
          command = "${sway}/bin/sway";
          user = "${profile.name}";
        };
        default_session = initial_session;
      };
    };
  };
}
