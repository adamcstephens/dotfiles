{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        bat
        colordiff
        ctags
        direnv
        firefox
        fzf
        gnumake
        htop
        httpie
        jq
        kitty
        neovim
        nmap
        python37Packages.yamllint
        redshift
        shellcheck
        silver-searcher
        slack
        tdesktop
        tmux
        tree
        vscodium
        wget
        xcape
      ];
    };
  };
}
