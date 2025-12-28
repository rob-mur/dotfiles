{ ... }: let

  profile = import ./../../user/profile {};

in {
  time.timeZone = "${profile.timezone}";
}
