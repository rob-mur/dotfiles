{
  config,
  lib,
  pkgs,
  ...
}: let
  # The nixpkgs this host was built from, used as a flake ref. Pinning to it
  # (rather than the `nixpkgs` registry entry) means a lazily-fetched binary
  # is the same build the host would have installed eagerly: maximum store
  # sharing, maximum cache.nixos.org hit rate, and no network round-trip to
  # resolve the registry on every miss.
  #
  # toString, not "${pkgs.path}": interpolating a *path* value re-adds the
  # nixpkgs tree to the store under a fresh hash, which measured as a 451 MB
  # duplicate on the phone. toString yields the store path it already lives
  # at. The cost is that the string carries no context, so nixpkgs is not a
  # registered dependency — the script handles that at runtime below.
  flake = toString pkgs.path;

  # nix-locate with the prebuilt index, so the command -> attribute fallback
  # below actually has something to look in.
  nixLocate = import ../packages/nix-locate.nix {inherit pkgs;};

  # Cache generation = the nixpkgs revision. Baked into both the PATH entry
  # and the script, so bumping nixpkgs silently starts a fresh cache instead
  # of leaving binaries pinned to a years-old revision. The stale generations
  # are pruned on activation below.
  gen = builtins.substring 0 8 (baseNameOf flake);

  stateDir = "${config.xdg.stateHome}/autobin";
  genDir = "${stateDir}/${gen}";
  binDir = "${genDir}/bin";

  # Resolve an unknown command to a nixpkgs binary, link it into binDir, run
  # it. Every later invocation is a plain PATH hit with no nix involvement —
  # the directory accretes instead of being faked by a filesystem, which is
  # what makes this work without FUSE or mount namespaces.
  autobin = pkgs.writeShellScriptBin "autobin" ''
    set -u

    cmd=''${1-}
    [ -n "$cmd" ] || { echo "usage: autobin <command> [args...]" >&2; exit 2; }
    shift

    # The handler only ever passes a bare command name; anything else is a
    # caller bug and must not reach `nix build`.
    case "$cmd" in
      */* | -* | .* | "") exit 127 ;;
    esac

    bin="${binDir}"
    roots="${genDir}/roots"
    misses="${genDir}/misses"

    notfound() { printf '%s: command not found\n' "$cmd" >&2; exit 127; }

    [ -x "$bin/$cmd" ] && exec "$bin/$cmd" "$@"

    # Negative cache: an agent with a typo in a loop must not re-evaluate
    # nixpkgs every time. Entries go stale after an hour, so a resolution
    # that failed for a reason other than "no such attribute" — two agents
    # racing on the same out-link, a network blip, nix-index not installed
    # yet — costs one wasted hour of that command, not a permanent poisoning.
    if [ -e "$misses/$cmd" ] &&
      [ -z "$(${pkgs.findutils}/bin/find "$misses/$cmd" -mmin +60 2>/dev/null)" ]; then
      notfound
    fi

    mkdir -p "$bin" "$roots" "$misses" || notfound
    command -v nix >/dev/null 2>&1 || notfound

    # The pin is a plain string with no nix dependency on it (see `flake`
    # above), so a garbage collection can take the nixpkgs tree with it.
    # Degrade to the registry rather than failing every lookup from then on.
    flake="${flake}"
    [ -d "$flake" ] || flake=nixpkgs

    # --max-jobs 0 is load-bearing: without it a package missing from the
    # binary cache is compiled locally, which on a phone means an agent's
    # stray command silently burns an hour. Fail fast instead.
    build() {
      nix build --max-jobs 0 --out-link "$roots/$1" \
        --print-out-paths "$flake#$1" 2>/dev/null
    }

    # Most commands are their own attribute name; that path needs no index
    # and hits the eval cache, so it stays the fast one.
    out=$(build "$cmd") || out=

    # Everything else goes through the index: rg -> ripgrep, nvim -> neovim.
    #
    # Dozens of packages can ship the same binary name and nix-locate returns
    # them unranked, so a wrong pick is the real hazard here, not a missing
    # one: /bin/tar is offered by u-root-cmds, uutils-tar, gash-utils and
    # busybox before gnutar, and silently handing out a Go reimplementation of
    # tar is far worse than reporting nothing. So only a confident match is
    # accepted, in this order, and anything else stays unresolved:
    #
    #   1. an attribute named exactly after the command
    #   2. one whose meta.mainProgram is the command (gnutar -> tar,
    #      ripgrep -> rg, silver-searcher -> ag), shortest name winning the
    #      tie so gnumake beats gnumake42 and nodejs beats nodejs-slim_22
    #   3. a sole candidate, where there is nothing to be wrong about
    #
    # Step 2 doubles as an existence check: the index is built from
    # nixpkgs-unstable and this host may be pinned to a release, so an
    # attribute can be suggested that does not exist here, and the eval fails.
    #
    # -t x -t s because plenty of binaries are symlinks (gawk's /bin/awk);
    # without the symlink type they are missing from the candidates entirely.
    if [ -z "$out" ]; then
      candidates=$(${lib.getExe nixLocate} --minimal --at-root --whole-name -t x -t s "/bin/$cmd" 2>/dev/null |
        ${pkgs.gnused}/bin/sed 's/\.out$//')
      count=$(printf '%s\n' "$candidates" | ${pkgs.gawk}/bin/awk 'NF { n++ } END { print n + 0 }')

      attr=
      # Unquoted on purpose throughout: the candidate list is newline
      # separated and split into words here.
      for a in $candidates; do
        [ "$a" = "$cmd" ] && {
          attr=$a
          break
        }
      done

      if [ -z "$attr" ]; then
        n=0
        for a in $candidates; do
          n=$((n + 1))
          [ "$n" -gt 8 ] && break
          [ "$(nix eval --raw "$flake#$a.meta.mainProgram" 2>/dev/null)" = "$cmd" ] || continue
          if [ -z "$attr" ] || [ "''${#a}" -lt "''${#attr}" ]; then attr=$a; fi
        done
      fi

      if [ -z "$attr" ] && [ "$count" -eq 1 ]; then
        for a in $candidates; do attr=$a; done
      fi

      [ -n "$attr" ] && { out=$(build "$attr") || out=; }
    fi
    [ -n "$out" ] || { : >"$misses/$cmd"; notfound; }

    # Confirm the package actually provides this command before linking
    # anything. An attribute can resolve and build and still ship nothing by
    # that name — `bind` builds ISC BIND, whose binaries are named, dig, host
    # and friends, with no /bin/bind anywhere. Linking first and checking
    # afterwards put all twenty-odd of those on PATH as the side effect of a
    # lookup that then reported "command not found".
    #
    # $out is newline-separated (a multi-output derivation prints one store
    # path per line) and left unquoted so the default IFS splits it.
    found=
    for path in $out; do
      [ -x "$path/bin/$cmd" ] && {
        found=1
        break
      }
    done
    [ -n "$found" ] || { : >"$misses/$cmd"; notfound; }

    # Now link every binary of every output: a package is asked for by one of
    # its commands but usually ships a related set, and having the rest
    # resolve for free is the point (man/dev outputs have no bin/).
    for path in $out; do
      [ -d "$path/bin" ] || continue
      for f in "$path"/bin/*; do
        [ -x "$f" ] || continue
        ln -sfn "$f" "$bin/''${f##*/}"
      done
    done

    exec "$bin/$cmd" "$@"
  '';

  # Appended, never prepended: a properly installed package must always win
  # over a lazily-cached one. Idempotent, because .zshenv runs for every zsh.
  pathInit = ''
    case ":$PATH:" in
      *:${binDir}:*) ;;
      *) PATH="$PATH:${binDir}" ;;
    esac
    export PATH
  '';

  # Non-interactive bash reads neither .bashrc nor .profile, so BASH_ENV is
  # the only hook that reaches `bash -c`, which is the shape agents use.
  bashEnv = pkgs.writeText "autobin-bash-env.sh" ''
    ${pathInit}
    command_not_found_handle() { ${autobin}/bin/autobin "$@"; }
  '';
in {
  # nix-locate is installed, not just referenced: the same lookup is useful by
  # hand ("which package has this binary?"), and autobin calls it by absolute
  # path regardless, so the handler never depends on PATH being right.
  home.packages = [autobin nixLocate];

  # .zshenv is read by *every* zsh, non-interactive `zsh -c` included — and
  # unlike .zshrc it survives the shell Claude Code's Bash tool spawns.
  programs.zsh.envExtra = ''
    ${pathInit}
    command_not_found_handler() { ${autobin}/bin/autobin "$@"; }
  '';

  home.sessionVariables.BASH_ENV = "${bashEnv}";
  programs.bash.bashrcExtra = lib.mkAfter ''
    source ${bashEnv}
  '';

  # Drop caches keyed to older nixpkgs revisions. Their roots/ entries are
  # GC roots, so without this every bump permanently pins another generation
  # of lazily-fetched packages into the store.
  home.activation.autobinPrune = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${stateDir}" ]; then
      $DRY_RUN_CMD ${pkgs.findutils}/bin/find "${stateDir}" \
        -mindepth 1 -maxdepth 1 ! -name "${gen}" -exec rm -rf {} +
    fi
  '';
}
