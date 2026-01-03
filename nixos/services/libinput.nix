{ ... }: {
  services = {
    libinput = {
      enable = true;
      mouse = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };
  };
}
