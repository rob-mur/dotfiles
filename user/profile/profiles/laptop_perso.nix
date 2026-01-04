{config, ...}: let
  locale = "en_GB.UTF-8";
  hostname = "nixos"; # laptop/pc name
  timezone = "Europe/Paris"; # time zone region
  version = "25.11"; # nixos version
  layout = "us_qwerty-fr"; # layout language
  pass = "pass"; # password store dir
  name = "robm"; # user name
  group = "users"; # group name
  email = "rmurphyswimmer@gmail.com"; # email
  fullname = "Rob Murphy"; # your fullname
in {
  inherit locale;
  inherit hostname;
  inherit timezone;
  inherit version;
  inherit layout;
  inherit pass;
  inherit name;
  inherit group;
  inherit email;
  inherit fullname;
}
