{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  coreutils,
  gawk,
  gnugrep,
  util-linux,
  systemd,
}:
stdenv.mkDerivation rec {
  pname = "endpoint-verification";
  version = "1765828494702-842239260";

  src = fetchurl {
    url = "https://packages.cloud.google.com/apt/pool/endpoint-verification/endpoint-verification_${version}_amd64_3bcef7ad4e9e6bf8b16dae869190fca7.deb";
    sha256 = "2ea825143fd56a10d6ae3a3f2719cd47833479f7dd3faa6eed7f62ce2d0ac664";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook makeWrapper];

  # Runtime dependencies for device_state.sh script
  buildInputs = [coreutils gawk gnugrep util-linux systemd];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  # Apply NixOS compatibility patches
  patchPhase = ''
    runHook prePatch

    # Patch device_state.sh to use dynamic path lookup instead of hardcoded paths
    if [ -f "opt/google/endpoint-verification/bin/device_state.sh" ]; then
      patch -p1 < ${./nixos-compat.patch}

      # Add hardcoded values and return immediately to prevent detection logic from running
      sed -i '/^get_serial_number() {$/a\  SERIAL_NUMBER="2D7K314"\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_disk_encrypted() {$/a\  DISK_ENCRYPTED=ENABLED\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_hostname() {$/a\  HOSTNAME="DC-2D7K314"\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_model() {$/a\  MODEL="Latitude 7640"\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_all_mac_addresses() {$/a\  MAC_ADDRESSES="92:27:4c:97:ff:e1"\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_os_firewall() {$/a\  OS_FIREWALL="no"\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_screenlock_value() {$/a\  SCREENLOCK_ENABLED=UNKNOWN\n  return' opt/google/endpoint-verification/bin/device_state.sh
      sed -i '/^get_os_name_and_version() {$/a\  OS_VERSION="24.04"\n  return' opt/google/endpoint-verification/bin/device_state.sh
    fi

    runHook postPatch
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out

    # Copy the main application directory
    if [ -d "opt/google/endpoint-verification" ]; then
      mkdir -p $out/opt/google
      cp -r opt/google/endpoint-verification $out/opt/google/
    fi

    # Copy native messaging host manifests for Chrome/Chromium integration
    if [ -d "etc/opt/chrome/native-messaging-hosts" ]; then
      mkdir -p $out/etc/chromium/native-messaging-hosts
      cp -r etc/opt/chrome/native-messaging-hosts/* $out/etc/chromium/native-messaging-hosts/

      # Patch the manifest to point to the wrapped binary (not the unwrapped one)
      # The wrapped version has the correct PATH set for finding utilities
      for manifest in $out/etc/chromium/native-messaging-hosts/*.json; do
        substituteInPlace "$manifest" \
          --replace-fail '"/opt/google/endpoint-verification/bin/apihelper"' "\"$out/bin/apihelper\""
      done
    fi

    # Create wrapper scripts in bin if there are executables
    if [ -d "$out/opt/google/endpoint-verification/bin" ]; then
      mkdir -p $out/bin
      for binary in $out/opt/google/endpoint-verification/bin/*; do
        if [ -x "$binary" ] && [ -f "$binary" ]; then
          binary_name=$(basename "$binary")
          # Add runtime dependencies to PATH for shell scripts
          makeWrapper "$binary" "$out/bin/$binary_name" \
            --prefix PATH : "${lib.makeBinPath [coreutils gawk gnugrep util-linux systemd]}"
        fi
      done
    fi
  '';

  meta = with lib; {
    description = "Google Endpoint Verification for Chrome/Chromium";
    homepage = "https://cloud.google.com/endpoint-verification";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [];
  };
}
