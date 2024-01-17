{ ... }:
{
  programs.git = {
    enable = true;

    extraConfig = {
      include = {
        path = "${./gitconfig}";
      };
    };

    ignores = [
      "*.log"
      "*.retry"
      ".DS_Store"
      ".direnv/"
      ".lsp/"
      ".worktree/"
      "result"
    ];
  };
}
