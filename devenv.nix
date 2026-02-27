{pkgs, ...}: {
  packages = with pkgs; [claude-code gemini-cli-bin];

  languages.javascript = {
    enable = true;
    npm.enable = true;
  };
}
