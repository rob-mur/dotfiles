{config, ...}: let
in {
  home-manager = {
    users.${config.name} = {
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
