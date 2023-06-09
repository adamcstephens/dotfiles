{...}: {
  imports = [
    ../xorg
  ];

  xsession = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      config = ./xmonad.hs;
    };
  };
}
