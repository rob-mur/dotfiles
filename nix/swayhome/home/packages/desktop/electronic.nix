{
  pkgs,
  ...
}:
with pkgs;
let

  profile = import ./../../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      home = {
        packages = [
          # kicad
        ];
      };
    };
  };
}
