{ config, lib, pkgs, ... }:

let
  endpoint-verification = pkgs.callPackage ./endpoint-verification/package.nix { };
in
{
  # Install the package system-wide
  environment.systemPackages = [ endpoint-verification ];

  # Set up native messaging host for Chromium
  environment.etc."chromium/native-messaging-hosts/com.google.endpoint_verification.api_helper.json" = {
    source = "${endpoint-verification}/etc/chromium/native-messaging-hosts/com.google.endpoint_verification.api_helper.json";
  };

  # Set up native messaging host for Google Chrome (if user has it)
  environment.etc."opt/chrome/native-messaging-hosts/com.google.endpoint_verification.api_helper.json" = {
    source = "${endpoint-verification}/etc/chromium/native-messaging-hosts/com.google.endpoint_verification.api_helper.json";
  };

  # Create required runtime directories and symlinks
  systemd.tmpfiles.rules = let
    deviceAttrsFile = pkgs.writeText "device_attrs" ''
      serial_number: "2D7K314"
      disk_encrypted: ENABLED
    '';
  in [
    # Create directory for device attributes storage
    "d /opt/google/endpoint-verification/var/lib 0755 root root -"

    # Create bin directory
    "d /opt/google/endpoint-verification/bin 0755 root root -"

    # Symlink wrapped binaries (from $out/bin) to expected location
    # These wrappers have the correct PATH set for all utilities
    "L+ /opt/google/endpoint-verification/bin/apihelper - - - - ${endpoint-verification}/bin/apihelper"
    "L+ /opt/google/endpoint-verification/bin/device_state.sh - - - - ${endpoint-verification}/bin/device_state.sh"

    # Create device_attrs file with hardcoded values
    # This file is read by apihelper to get serial number and disk encryption status
    "L+ /opt/google/endpoint-verification/var/lib/device_attrs - - - - ${deviceAttrsFile}"
  ];
}
