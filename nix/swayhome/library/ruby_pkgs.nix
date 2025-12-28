{
  pkgs,
  ruby_withpackages ? false,
  ...
}:
with pkgs;
let

  ruby_pkgs =
    if ruby_withpackages then
    (
    ruby.withPackages ( ps:
      with ps; [
        nokogiri
        pry
      ]
    )
  )
  else
    ruby;

in {

  inherit ruby_pkgs;

}
