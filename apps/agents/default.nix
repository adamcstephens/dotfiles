{ config, ... }:
let
  skills =
    if config.dotfiles.nixosManaged then
      ./skills
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/agents/skills";
in
{
  home.file.".claude/skills".source = skills;
  home.file.".config/agents/skills".source = skills;
}
