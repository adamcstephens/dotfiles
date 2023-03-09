{...}: {
  programs.git = {
    enable = true;

    # aliases = {
    #   ftag = "push --tags --force";
    #   home = "!git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'); git pull";
    #   fixhome = "remote set-head origin --auto";
    #   subup = "submodule update --remote --merge --recursive";
    #   yolo = "commit --amend --no-edit";
    # };

    extraConfig = {
      include = {
        path = "${./gitconfig}";
      };
      # color = {
      #   ui = true;
      # };
      # "color \"diff\"" = {
      #   meta = "blue";
      #   frag = "magenta";
      #   old = "red";
      #   new = "green";
      # };
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
    ];
  };
}
