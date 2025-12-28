{ ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        go = {
          enable = true;
          env = {
            GOBIN = ".go/bin";
            GOPATH = ".go";
          };
        };
      };
    };
  };
}
