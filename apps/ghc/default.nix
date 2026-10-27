{ ... }:
{
  xdg.configFile."ghc/ghci.conf".text = ''
    :set prompt "\n\SOH\ESC[90m\STX%s\SOH\ESC[0m\n\SOH\ESC[33m\STXλ\SOH\ESC[0m\STX > "
    :set prompt-cont "\SOH\ESC[33m\STXλ+\SOH\ESC[0m\STX| "
  '';
}
