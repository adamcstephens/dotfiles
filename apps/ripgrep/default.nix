{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "ripgrep-dotfiles-wrapped";
      paths = [pkgs.ripgrep];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/rg" --set RIPGREP_CONFIG_PATH ${./ripgreprc}
      '';
    })
  ];
}
