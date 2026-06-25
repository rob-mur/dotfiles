{
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    # Static timezone (desktop and anything that doesn't move)
    (lib.mkIf (!config.autoTimezone) {
      time.timeZone = "${config.timezone}";
    })

    # Automatic, location-based timezone (laptops). Updates live as you move
    # between countries. Relies on GeoClue, which locates you primarily by
    # scanning nearby WiFi access points, so WiFi must be on. time.timeZone is
    # left unset here, as automatic-timezoned requires.
    (lib.mkIf config.autoTimezone {
      services.automatic-timezoned.enable = true;
      services.geoclue2.enable = true;
    })
  ];
}
