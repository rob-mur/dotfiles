{
  pkgs,
  config,
  ...
}:
with pkgs; let
  theme = import ./../../user/theme {};
in {
  programs = {
    vscode = {
      enable = true;
      profiles = {
        default = {
          extensions = with vscode-extensions; [
            ms-vscode-remote.remote-containers
          ];
        };
      };
    };
  };
}
