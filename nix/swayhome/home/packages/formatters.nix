{
  pkgs,
  config,
  ...
}: let
in {
  home-manager = {
    users.${config.name} = {
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
