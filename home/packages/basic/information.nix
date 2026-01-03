{
  pkgs,
  enable_information_pkgs ? false,
  ...
}:
with pkgs;
let

  information_pkgs =
    if enable_information_pkgs then [
      acpi
      clinfo
      cpufetch
      cpufetch
      dig
      disfetch
      dmidecode
      dysk
      foodfetch
      kmon
      leaf
      lshw
      mesa-demos
      microfetch
      mmtui
      onefetch
      radeontop
    ]
    else
      [];
in {

  inherit information_pkgs;
}

