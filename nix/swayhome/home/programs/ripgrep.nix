{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        ripgrep = {
          enable = true;
          arguments = [
            "--max-columns-preview"
            "--colors=line:style:bold"
          ];
        };
      };
    };
  };
}
