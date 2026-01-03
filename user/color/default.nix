{ ... }: let

  # Colors without hastag
  primary = "${bright_blue}";
  r_primary = "${r_bright_blue}";

  h_primary = "#${primary}";
  f_primary = "#${primary}FF";
  q_primary = "'#${primary}'";

  black = "26292D";
  red = "ED1515";
  green = "11D116";
  yellow = "F67400";
  blue = "1E92FF";
  purple = "9B59B6";
  cyan = "1ABC9C";
  white = "EFF0F1";
  bright_black = "4F5255";
  bright_red = "C0392B";
  bright_green = "1CDC9A";
  bright_yellow = "FDBC4B";
  bright_blue = "3DAEE9";
  bright_purple = "8E44AD";
  bright_cyan = "16A085";
  bright_white = "FCFCFC";
  background = "31363B";
  foreground = "EFF0F1";

  # Colors with hastag
  h_black = "#${black}";
  h_red = "#${red}";
  h_green = "#${green}";
  h_yellow = "#${yellow}";
  h_blue = "#${blue}";
  h_purple = "#${purple}";
  h_cyan = "#${cyan}";
  h_white = "#${white}";
  h_bright_black = "#${bright_black}";
  h_bright_red = "#${bright_red}";
  h_bright_green = "#${bright_green}";
  h_bright_yellow = "#${bright_yellow}";
  h_bright_blue = "#${bright_blue}";
  h_bright_purple = "#${bright_purple}";
  h_bright_cyan = "#${bright_cyan}";
  h_bright_white = "#${bright_white}";
  h_background = "#${background}";
  h_foreground = "#${foreground}";

  # Colors with hastag & alpha
  f_black = "#${black}FF";
  f_red = "#${red}FF";
  f_green = "#${green}FF";
  f_yellow = "#${yellow}FF";
  f_blue = "#${blue}FF";
  f_purple = "#${purple}FF";
  f_cyan = "#${cyan}FF";
  f_white = "#${white}FF";
  f_bright_black = "#${bright_black}FF";
  f_bright_red = "#${bright_red}FF";
  f_bright_green = "#${bright_green}FF";
  f_bright_yellow = "#${bright_yellow}FF";
  f_bright_blue = "#${bright_blue}FF";
  f_bright_purple = "#${bright_purple}FF";
  f_bright_cyan = "#${bright_cyan}FF";
  f_bright_white = "#${bright_white}FF";
  f_background = "#${background}FF";
  f_foreground = "#${foreground}FF";

  # Colors with hastag & double-single quote
  q_black = "'#${black}'";
  q_red = "'#${red}'";
  q_green = "'#${green}'";
  q_yellow = "'#${yellow}'";
  q_blue = "'#${blue}'";
  q_purple = "'#${purple}'";
  q_cyan = "'#${cyan}'";
  q_white = "'#${white}'";
  q_bright_black = "'#${bright_black}'";
  q_bright_red = "'#${bright_red}'";
  q_bright_green = "'#${bright_green}'";
  q_bright_yellow = "'#${bright_yellow}'";
  q_bright_blue = "'#${bright_blue}'";
  q_bright_purple = "'#${bright_purple}'";
  q_bright_cyan = "'#${bright_cyan}'";
  q_bright_white = "'#${bright_white}'";
  q_background = "'#${background}'";
  q_foreground = "'#${foreground}'";

  # Colors with rgba
  r_black = "rgba(49, 54, 59, 1.00)";
  r_red = "rgba(237, 21, 21, 1.00)";
  r_green = "rgba(17, 209, 22, 1.00)";
  r_yellow = "rgba(246, 116, 0, 1.00)";
  r_blue = "rgba(29, 153, 243, 1.00)";
  r_purple = "rgba(155, 89, 182, 1.00)";
  r_cyan = "rgba(26, 188, 156, 1.00)";
  r_white = "rgba(239, 240, 241, 1.00)";
  r_bright_black = "rgba(127, 140, 141, 1.00)";
  r_bright_red = "rgba(192, 57, 43, 1.00)";
  r_bright_green = "rgba(28, 220, 154, 1.00)";
  r_bright_yellow = "rgba(253, 188, 75, 1.00)";
  r_bright_blue = "rgba(61, 174, 233, 1.00)";
  r_bright_purple = "rgba(142, 68, 173, 1.00)";
  r_bright_cyan = "rgba(22, 160, 133, 1.00)";
  r_bright_white = "rgba(252, 252, 252, 1.00)";
  r_background = "rgba(49, 54, 59, 1.00)";
  r_foreground = "rgba(239, 240, 241, 1.00)";
  r_cursorColor = "rgba(239, 240, 241, 1.00)";
  r_selectionBackground = "rgba(239, 240, 241, 1.00)";

in {

  inherit primary;
  inherit h_primary;
  inherit f_primary;
  inherit q_primary;
  inherit r_primary;

  inherit black;
  inherit red;
  inherit green;
  inherit yellow;
  inherit blue;
  inherit purple;
  inherit cyan;
  inherit white;
  inherit bright_black;
  inherit bright_red;
  inherit bright_green;
  inherit bright_yellow;
  inherit bright_blue;
  inherit bright_purple;
  inherit bright_cyan;
  inherit bright_white;
  inherit background;
  inherit foreground;

  inherit h_black;
  inherit h_red;
  inherit h_green;
  inherit h_yellow;
  inherit h_blue;
  inherit h_purple;
  inherit h_cyan;
  inherit h_white;
  inherit h_bright_black;
  inherit h_bright_red;
  inherit h_bright_green;
  inherit h_bright_yellow;
  inherit h_bright_blue;
  inherit h_bright_purple;
  inherit h_bright_cyan;
  inherit h_bright_white;
  inherit h_background;
  inherit h_foreground;

  inherit f_black;
  inherit f_red;
  inherit f_green;
  inherit f_yellow;
  inherit f_blue;
  inherit f_purple;
  inherit f_cyan;
  inherit f_white;
  inherit f_bright_black;
  inherit f_bright_red;
  inherit f_bright_green;
  inherit f_bright_yellow;
  inherit f_bright_blue;
  inherit f_bright_purple;
  inherit f_bright_cyan;
  inherit f_bright_white;
  inherit f_background;
  inherit f_foreground;

  inherit q_black;
  inherit q_red;
  inherit q_green;
  inherit q_yellow;
  inherit q_blue;
  inherit q_purple;
  inherit q_cyan;
  inherit q_white;
  inherit q_bright_black;
  inherit q_bright_red;
  inherit q_bright_green;
  inherit q_bright_yellow;
  inherit q_bright_blue;
  inherit q_bright_purple;
  inherit q_bright_cyan;
  inherit q_bright_white;
  inherit q_background;
  inherit q_foreground;

  inherit r_black;
  inherit r_red;
  inherit r_green;
  inherit r_yellow;
  inherit r_blue;
  inherit r_purple;
  inherit r_cyan;
  inherit r_white;
  inherit r_bright_black;
  inherit r_bright_red;
  inherit r_bright_green;
  inherit r_bright_yellow;
  inherit r_bright_blue;
  inherit r_bright_purple;
  inherit r_bright_cyan;
  inherit r_bright_white;
  inherit r_background;
  inherit r_foreground;
  inherit r_cursorColor;
  inherit r_selectionBackground;

}
