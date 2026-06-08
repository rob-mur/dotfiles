{
  pkgs,
  config,
  ...
}: let
in {
  home = {
        packages = with pkgs; [
          alejandra
          stylua
          prettier
          black
        ];
  };
}
