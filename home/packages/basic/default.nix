{
  pkgs,
  config,
  ...
}: let
  archive = import ./archive.nix {
    inherit pkgs;
    enable_archive_pkgs = true;
  };

  deploy = import ./deploy.nix {
    inherit pkgs;
    enable_deploy_pkgs = true;
  };

  document = import ./document.nix {
    inherit pkgs;
    enable_document_pkgs = true;
  };

  downloader = import ./downloader.nix {
    inherit pkgs;
    enable_downloader_pkgs = false;
  };

  generator = import ./generator.nix {
    inherit pkgs;
    enable_generator_pkgs = true;
  };

  information = import ./information.nix {
    inherit pkgs;
    enable_information_pkgs = false;
  };

  libsqt5 = import ./libsqt5.nix {
    inherit pkgs;
    enable_libsqt5_pkgs = true;
  };

  libsqt6 = import ./libsqt6.nix {
    inherit pkgs;
    enable_libsqt6_pkgs = true;
  };

  media = import ./media.nix {
    inherit pkgs;
    enable_media_pkgs = true;
  };

  nvtop = import ./nvtop.nix {
    inherit pkgs;
    enable_nvtop_pkgs = false;
  };

  utility = import ./utility.nix {
    inherit pkgs;
    enable_utility_pkgs = true;
  };

  wayland = import ./wayland.nix {
    inherit pkgs;
    enable_wayland_pkgs = true;
  };

  wine = import ./wine.nix {
    inherit pkgs;
    enable_wine = false;
  };

  all_basic_pkgs =
    archive.archive_pkgs
    ++ deploy.deploy_pkgs
    ++ document.document_pkgs
    ++ downloader.downloader_pkgs
    ++ generator.generator_pkgs
    ++ information.information_pkgs
    ++ libsqt5.libsqt5_pkgs
    ++ libsqt6.libsqt6_pkgs
    ++ media.media_pkgs
    ++ nvtop.nvtop_pkgs
    ++ utility.utility_pkgs
    ++ wayland.wayland_pkgs
    ++ wine.wine_pkgs;
in {
  home = {
        packages = all_basic_pkgs;
  };
}
