{pkgs, ...}: let
  profile = import ./../../../user/profile {};
in {
  home-manager = {
    users.${profile.name} = {
      home = {
        packages = with pkgs; [
          alejandra
          stylua
          nodePackages.prettier
          black
        ];
      };
    };
  };
}
