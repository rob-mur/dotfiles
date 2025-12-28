{
  pkgs,
  ...
}:
let

  profile = import ./../../../user/profile {};
  julia_list = import ./../../../library/julia_pkgs.nix {
    inherit pkgs;
  };

in {

  home-manager = {
    users.${profile.name} = {
      home = {
        packages = [
          julia_list.julia_pkgs
        ];
      };
    };
  };
}
