# nix-locate backed by the prebuilt weekly index from
# nix-community/nix-index-database, so a command -> attribute lookup works
# without ever running the `nix-index` indexer — that walks the whole binary
# cache file listing, which is hours of work and gigabytes of traffic.
#
# The "small" index covers /bin only. That is exactly what a command lookup
# needs, and it is 1.7 MB against 101 MB for the full one, which is the
# difference between viable and not on a phone.
#
# Bumping: pick a release from
# https://github.com/nix-community/nix-index-database/releases and copy the
# matching `*-small` hashes out of that tag's generated.nix.
{pkgs}: let
  release = "2026-09-27-083517";
  hashes = {
    aarch64-linux = "sha256-1TqhPiO2vYf46Uju0IaIPfmIR6bYutVS9QKQxar4Mj0=";
    x86_64-linux = "sha256-9PU4T/8oicqb/qEhNU9hZ9Jh7gMIoZmKVc2jiRPHB3Q=";
    aarch64-darwin = "sha256-UIe55mh35D/TdE6VUqBndjJJZ7jC1eAvUkU8bVa5tao=";
  };

  inherit (pkgs.stdenv.hostPlatform) system;

  # The index stores store paths as plain text. Without discarding references
  # nix scans them and makes an arbitrary slice of the store a runtime
  # dependency of a 1.7 MB file. Upstream's own packaging does the same.
  db =
    (pkgs.fetchurl {
      url = "https://github.com/nix-community/nix-index-database/releases/download/${release}/index-${system}-small";
      hash =
        hashes.${system}
        or (throw "nix-locate: no prebuilt index for ${system}; add its hash from the release's generated.nix");
    })
    .overrideAttrs {
      __structuredAttrs = true;
      unsafeDiscardReferences.out = true;
    };

  # nix-locate wants a directory holding a file literally named "files".
  dbDir = pkgs.linkFarm "nix-index-database" {files = db;};
in
  # Only nix-locate is wrapped and exposed: the indexer half would be useless
  # here, since the whole point is to never build an index locally.
  pkgs.runCommand "nix-locate-with-db-${pkgs.nix-index.version}" {
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    meta.mainProgram = "nix-locate";
  } ''
    mkdir -p $out/bin
    makeBinaryWrapper ${pkgs.nix-index}/bin/nix-locate $out/bin/nix-locate \
      --set NIX_INDEX_DATABASE ${dbDir}
  ''
