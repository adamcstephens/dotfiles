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

  smfh.xdg.config.files = {
    "opencode/.stignore".source = dotlib.source "apps/opencode/.stignore";
    "opencode/AGENTS.md".source = dotlib.source "apps/agents/AGENTS.md";
    "opencode/skills".source = dotlib.source "apps/agents/skills";
  };
}
