{
  dotlib,
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.nixos-unstable-small.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  xdg.configFile = {
    "opencode/.stignore".source = dotlib.source "apps/opencode/.stignore";
    "opencode/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
    "opencode/skills".source = dotlib.source "apps/agents/skills";
  };
}
