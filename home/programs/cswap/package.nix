# cswap (realiti4/claude-swap): multi-account switcher for Claude Code.
# Not in nixpkgs, so it is built from the upstream tag. Takes the unstable
# python set: upstream wants textual >= 8.2.8, which the stable channel lags.
{pkgs}:
pkgs.python3Packages.buildPythonApplication rec {
  pname = "claude-swap";
  version = "0.29.0";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "realiti4";
    repo = "claude-swap";
    tag = "v${version}";
    hash = "sha256-uESik88Anao+fhAIqIfU8+ATSM8ps129LL7PgkmgUdc=";
  };

  build-system = [pkgs.python3Packages.hatchling];
  dependencies = with pkgs.python3Packages; [textual truststore];

  # The suite spawns Claude Code and Textual pilots; it is upstream's to run.
  doCheck = false;

  meta = {
    description = "Multi-account switcher for Claude Code";
    homepage = "https://github.com/realiti4/claude-swap";
    license = pkgs.lib.licenses.mit;
    mainProgram = "cswap";
  };
}
