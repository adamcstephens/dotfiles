{...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    history = {
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      size = 100000;
    };
  };
}
