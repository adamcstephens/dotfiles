{ lib, pkgs, ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      command_timeout = 100;

      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$localip"
        "$shlvl"
        "$directory"
        "$vcsh"
        "$fossil_branch"
        "$fossil_metrics"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$hg_branch"
        "$pijul_channel"
        "$shell"
        "$cmd_duration"
        "$line_break"

        # line 2
        "$character"
      ];

      character = {
        format = "[](fg:244)$symbol ";
        success_symbol = "[➜](bold yellow)";
        error_symbol = "[✗](bold red)";
      };

      git_branch.symbol = "";

      hostname = {
        style = "bold yellow";
        format = "[$hostname]($style) ";
        trim_at = "";
      };

      shell = {
        disabled = false;
        fish_indicator = "";
        format = "[$indicator]($style)";
        style = "fg:244";
      };

      sudo = {
        disabled = false;
        format = "";
      };

      username = {
        style_user = "fg:244";
        format = "[$user@]($style)";
      };
    };
  };
}
