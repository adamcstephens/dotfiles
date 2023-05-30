{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  dependencies = [
    pkgs.bash
    pkgs.networkmanagerapplet
    pkgs.pavucontrol
    pkgs.playerctl
  ];

  path = "PATH=${config.services.polybar.package}/bin:${lib.makeBinPath dependencies}:/run/wrappers/bin";

  fontconfig_file = pkgs.makeFontsConf {
    fontDirectories = [
      (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
      pkgs.font-awesome
      pkgs.jetbrains-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
    ];
  };
in {
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = "polybar bar &";

    extraConfig =
      (with config.colorScheme.colors; ''
        [colors]
        background = ${base00}
        background-alt = ${base00}
        foreground = ${base05}
        primary = ${base0A}
        secondary = ${base0C}
        disabled = ${base03}
        border = ${base03}
        red = ${base08}
        green = ${base0B}
        blue = ${base0D}

        [scripts]
        player = ${./player.sh}
      '')
      + (builtins.readFile ./config.ini);
  };

  systemd.user.services.polybar = {
    Install.WantedBy = lib.mkForce ["xserver-session.target"];
    Unit.PartOf = lib.mkForce ["xserver-session.target"];
    Service.Environment = lib.mkForce [
      path
      "FONTCONFIG_FILE=${fontconfig_file}"
    ];
  };
}
