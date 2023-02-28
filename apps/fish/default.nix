{
  config,
  inputs,
  pkgs,
  ...
}: let
  nix-colors-contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
in {
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.fzf-fish
  ];

  programs.fish = {
    enable = true;
    plugins = [];

    shellInit = ''
      if test -e $HOME/.nix-profile/share/fish/vendor_completions.d
          set --prepend --export fish_complete_path ~/.nix-profile/share/fish/vendor_completions.d
      end

      if test -e $HOME/.nix-profile/share/fish/vendor_functions.d
          set --prepend --export fish_function_path ~/.nix-profile/share/fish/vendor_functions.d
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end
    '';

    interactiveShellInit = ''
      set -U __done_notification_urgency_level_failure normal
    '';

    shellAliases = {
      cat = "bat";
      cnf = "command-not-found";
      l = "ll -a";
      nix = "nix --print-build-logs";
      dog = "doggo";
    };
  };
}
