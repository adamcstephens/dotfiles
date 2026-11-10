{ pkgs, ... }:
{
  home.packages = [
    pkgs.direnv
    pkgs.nix-direnv
  ];

  xdg.configFile."direnv/direnvrc".text = ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc

    # Apply after .envrc so direnv tracks and restores the PATH override.
    __dump_at_exit() {
      local ret=$?
      PATH_add ${pkgs.bashInteractive}/bin
      "$direnv" dump json "" >&3
      trap - EXIT
      exit "$ret"
    }
  '';
}
