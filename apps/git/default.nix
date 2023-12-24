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
      "*.sw?"
      ".bundle"
      ".ruby-version"
      ".notags"
      ".tags"
      ".tags.lock"
      ".DS_Store"
      ".elixir_ls/"
      "result"
      ".direnv/"
      ".calva/"
      ".clj-kondo/"
      ".lsp/"
    ];
  };
}
