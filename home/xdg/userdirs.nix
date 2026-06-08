{config, ...}: let
in {
  xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
          # 26.05 changed the default to false; keep exporting XDG_*_DIR vars.
          setSessionVariables = true;
          desktop = "\$HOME/Desktop";
          documents = "\$HOME/Documents";
          download = "\$HOME/Downloads";
          music = "\$HOME/Music";
          pictures = "\$HOME/Pictures";
          publicShare = "\$HOME/Public";
          templates = "\$HOME/Templates";
          videos = "\$HOME/Videos";
    };
  };
}
