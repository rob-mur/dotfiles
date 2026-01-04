{
  pkgs,
  enable_generator_pkgs ? false,
  ...
}:
with pkgs;
let

  generator_pkgs =
    if enable_generator_pkgs then [
      hugo
      quarto
      sqlpage
      zola

      ## Optional:
      # gnuplot
      # iredis
      # litecli
      # luigi
      # mpi
    ]
    else
      [];
in {

  inherit generator_pkgs;
}

