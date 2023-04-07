{pkgs, ...}: {
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.fzf-fish
  ];

  programs.fish = {
    enable = true;
    plugins = [];

    shellInit =
      ''
        fish_add_path --prepend --move ~/.dotfiles/bin
      ''
      + (
        if pkgs.stdenv.isDarwin
        then ''
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

          if test -x /opt/homebrew/bin/brew
              # eval (/opt/homebrew/bin/brew shellenv)
              # do this manually to avoid homebrew overriding nix
              set -gx HOMEBREW_PREFIX /opt/homebrew
              set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
              set -gx HOMEBREW_REPOSITORY /opt/homebrew
              set --append -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
              set --append -gx MANPATH /opt/homebrew/share/man $MANPATH
              set --append -gx INFOPATH /opt/homebrew/share/info $INFOPATH
          end
        ''
        else ""
      );

    interactiveShellInit = ''
       if [ (uname) = Darwin ] && [ -e "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh" ]
         set -x SSH_AUTH_SOCK "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
       end

       set -U __done_notification_urgency_level_failure normal
       set -U fish_greeting

       if [ -z "$SSH_AUTH_SOCK" ]
           if [ -S "$XDG_RUNTIME_DIR/ssh-agent" ]
             set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent"
           end
           if [ -S "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock" ]
             set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
           end
       end

       if [ -n $SSH_AUTH_SOCK ] && ! ssh-add -l &>/dev/null
           if [ (uname) = Darwin ]
               ssh-add --apple-use-keychain
           else
               echo "Emtpy ssh-agent"
           end
       end

       if [ -e $HOME/.shell_local.sh ]
           fenv source $HOME/.shell_local.sh
       end

      if string match -q "$TERM_PROGRAM" vscode
          if ! command -q code
              set VSCODE_PATH (echo $BROWSER | sed 's,helpers/browser.sh,remote-cli,')
              if test -d $VSCODE_PATH
                  fish_add_path $VSCODE_PATH
              end
          end

          if command -q code
              . (code --locate-shell-integration-path fish 2>/dev/null | sed 's/shellIntegration-fish/shellIntegration/')
          end
      end
    '';

    shellAliases = {
      cat = "bat";
      cnf = "command-not-found";
      l = "ll -a";
      nix = "nix --print-build-logs";
      dog = "doggo";
    };

    functions = {
      esl = "exec fish -l";
      uas = "set -x SSH_AUTH_SOCK $(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')";
    };
  };
}
