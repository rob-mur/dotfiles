{
  pkgs,
  ...
}:
let

  profile = import ./../../../user/profile {};
  python_list = import ./../../../library/python_pkgs.nix {
    inherit pkgs;
  };

in {
  home-manager = {
    users.${profile.name} = {
      home = {
        packages = [
          python_list.python_pkgs
        ];
      };
    };
  };
}
