{
  pkgs,
  ...
}:
let

  profile = import ./../../../user/profile {};
  r_list = import ./../../../library/r_pkgs.nix {
    inherit pkgs;
  };

in {
  home-manager = {
    users.${profile.name} = {
      home = {
        packages = [
          r_list.r_pkgs
          # r_list.rstudio_pkgs
        ];
      };
    };
  };
}
