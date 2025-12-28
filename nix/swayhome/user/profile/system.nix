{ ... }: let

  defaultlocale = "en_GB.UTF-8";
  hostname = "nixos";                     # laptop/pc name
  timezone = "Europe/Paris";              # time zone region
  version = "25.11";                      # nixos version
  layout = "us_qwerty-fr";                          # layout language
  pass = "pass";                          # password store dir

in {

  inherit defaultlocale;
  inherit hostname;
  inherit timezone;
  inherit version;
  inherit layout;
  inherit pass;

}
