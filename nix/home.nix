{
  pkgs,
  nil,
  ...
}: {
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.alejandra
    pkgs.btop
    pkgs.du-dust
    pkgs.fzf
    pkgs.gh
    pkgs.go-task
    pkgs.htop
    pkgs.jq
    pkgs.lazygit
    pkgs.lsd
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.starship
    pkgs.zoxide
    nil.nil
  ];
}
