{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  perl,
  ghostscript,
  file,
  which,
  gnused,
  gnugrep,
  coreutils,
}: let
  model = "mfcl3740cdw";

  # The .deb ships both arches under lpd/<arch>/; we keep only ours.
  arches = ["x86_64" "i686"];

  # Commands the two Perl filters shell out to: `which gs`, `file`, `grep`,
  # `sed`, `mktemp`/`cat`/`cp`/`mv`/`touch` from coreutils.
  runtimeDeps = [ghostscript file which gnused gnugrep coreutils];
in
  stdenv.mkDerivation rec {
    pname = "cups-brother-mfcl3740cdw";
    version = "3.5.1-1";

    # Despite the ".i386" in the filename this archive carries both the i686
    # and the x86_64 binaries. URL taken from Brother's own download endpoint
    # (dlf105760 is the MFC-L3740CDW LPR + CUPS wrapper bundle).
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf105760/${model}pdrv-${version}.i386.deb";
      hash = "sha256-3weoQ4jJJ9h2fIm0LCyW9yY8dvuGESI26/isdmhzBZY=";
    };

    nativeBuildInputs = [dpkg autoPatchelfHook makeWrapper];
    # perl for the filter shebangs, libstdc++ for brmfcl3740cdwfilter.
    buildInputs = [perl stdenv.cc.cc.lib];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      dpkg-deb -x $src $out

      brdir="$out/opt/brother/Printers/${model}"

      # Drop the arches we are not building for, then hoist ours up into lpd/:
      # the bundled scripts look for lpd/br<model>filter, not lpd/<arch>/.
    ''
    + lib.concatMapStrings (arch: ''
      rm -r "$brdir/lpd/${arch}"
    '') (builtins.filter (arch: arch != stdenv.hostPlatform.linuxArch) arches)
    + ''
      cp "$brdir/lpd/${stdenv.hostPlatform.linuxArch}/"* "$brdir/lpd/"
      rm -r "$brdir/lpd/${stdenv.hostPlatform.linuxArch}"

      # Both Perl filters derive their install prefix and model name from $0 at
      # runtime (readlink/realpath plus a regex anchored on /opt). Neither
      # survives living in the Nix store or being wrapped, so hardcode them.
      # The trailing slash matters: the scripts concatenate "lpd/..." directly.
      substituteInPlace "$brdir/cupswrapper/brother_lpdwrapper_${model}" \
        --replace-fail 'my $basedir = `readlink $0`;' "my \$basedir = \"$brdir/\"; #" \
        --replace-fail '$PRINTER =~ s/^\/opt\/.*\/Printers\///g;' '$PRINTER = "${model}"; #'

      substituteInPlace "$brdir/lpd/filter_${model}" \
        --replace-fail 'my $PRINTER = $0;' 'my $PRINTER = "${model}"; #' \
        --replace-fail 'my $BR_PRT_PATH = Cwd::realpath ($0);' "my \$BR_PRT_PATH = \"$brdir/\"; #"

      # Wrap only the executables. The PPD also ships with its exec bit set, so
      # a blanket find -executable would replace it with a shell script.
      for f in \
        "$brdir/cupswrapper/brother_lpdwrapper_${model}" \
        "$brdir/lpd/filter_${model}" \
        "$brdir/lpd/br${model}filter" \
        "$brdir/lpd/brprintconf_${model}"; do
        wrapProgram "$f" --prefix PATH : "${lib.makeBinPath runtimeDeps}"
      done

      # Where CUPS actually looks: services.printing.drivers unions each
      # driver's /lib and /share/cups into ServerBin and DataDir.
      mkdir -p $out/lib/cups/filter $out/share/cups/model

      ln -s \
        "$brdir/cupswrapper/brother_lpdwrapper_${model}" \
        $out/lib/cups/filter/

      ln -s \
        "$brdir/cupswrapper/brother_${model}_printer_en.ppd" \
        $out/share/cups/model/

      runHook postInstall
    '';

    meta = {
      homepage = "https://www.brother.com/";
      description = "Brother MFC-L3740CDW LPR and CUPS wrapper printer driver";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      license = lib.licenses.unfree;
      platforms = map (arch: "${arch}-linux") arches;
      maintainers = [];
    };
  }
