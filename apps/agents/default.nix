{ config, ... }:
let
  skills =
    if config.dotfiles.nixosManaged then
      ./skills
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/agents/skills";

  AGENTS =
    if config.dotfiles.nixosManaged then
      ./AGENTS.md
    else
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/agents/AGENTS.md";
in
{
  home.file.".claude/CLAUDE.md".source = AGENTS;

  home.file.".claude/skills".source = skills;
  home.file.".config/agents/skills".source = skills;
}
