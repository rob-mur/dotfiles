{
  pkgs,
  cswap,
  primarySlot,
  secondarySlot,
}:
pkgs.writeShellApplication {
  name = "cswap-autoswitch";
  runtimeInputs = [cswap] ++ (with pkgs; [jq gawk coreutils]);
  runtimeEnv = {
    CSWAP_PRIMARY_SLOT = toString primarySlot;
    CSWAP_SECONDARY_SLOT = toString secondarySlot;
    CSWAP_BURNDOWN_LIB = "${../claude-code/burndown.sh}";
  };
  text = builtins.readFile ./autoswitch.sh;
}
