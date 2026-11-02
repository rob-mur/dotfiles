# Single source of truth for what dictation is taught. Rendered into
# [whisper] initial_prompt and [text] replacements by ./default.nix.
#
# Whisper cannot learn words at runtime. The prompt only nudges spelling and
# casing; the replacement table is the deterministic fix. Loop: when a word is
# mistranscribed, add ONE line to `replacements` (and the word to `extraTerms`
# if it matters), then rebuild.
{lib}: let
  # Top terms from the user's own prompts that no English wordlist knows.
  # Regenerate with ./mine-vocab.py (see its docstring).
  mined = import ./mined-terms.nix;

  # Hand-picked words the miner cannot find: ordinary-looking words that are
  # product names here, and domain terms.
  extraTerms = [
    "aegis"
    "Keycloak"
    "Descartes"
    "Sentry"
    "bordereau"
    "cedant"
    "dotfiles"
  ];

  # Case-insensitive de-dup, hand-picked spelling wins over the mined one.
  key = lib.toLower;
  taken = builtins.map key extraTerms;
  terms = extraTerms ++ builtins.filter (t: !(builtins.elem (key t) taken)) mined;

  prompt = "Software and insurance talk: " + builtins.concatStringsSep ", " terms + ".";
in
  # Whisper keeps ~224 tokens of prompt; ~3 tokens per rare word, so cap the
  # text well under that rather than count tokens exactly.
  assert builtins.stringLength prompt <= 600; {
    inherit terms prompt;

    # "what Whisper writes" = "what you meant". Case-insensitive match.
    # Only predictable misses are seeded; add the rest as they happen.
    replacements = {
      "you track" = "YouTrack";
      "git lab" = "GitLab";
      "key cloak" = "Keycloak";
      "first mate" = "Firstmate";
      "dev env" = "devenv";
      "dir env" = "direnv";
      "nix os" = "NixOS";
      "sonar cube" = "SonarQube";
      "forge jo" = "Forgejo";
      ".files" = "dotfiles";
    };
  }
