{...}: {
  xdg.configFile."ghc/ghci.conf".text = ''
    :set prompt "λ "
  '';
}
