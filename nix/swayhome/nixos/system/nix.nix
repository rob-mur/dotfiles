{ ... }: let

  profile = import ./../../user/profile {};

in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      firefox = {
        enablePlasmaBrowserIntegration = false;
      };
      permittedInsecurePackages = [ ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--max-freed 1G --delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      allowed-users = ["@wheel"];
      auto-optimise-store = true;
        extra-substituters = ["https://devenv.cachix.org"];
    extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
    experimental-features = ["nix-command" "flakes"];
    
      sandbox = true;
      trusted-users = [
        "root"
        "${profile.name}"
      ];
    };
  };
}
