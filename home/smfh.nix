{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.smfh;
  inherit (config.home) homeDirectory;
  fileOptions = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          source = lib.mkOption {
            type = lib.types.addCheck lib.types.str (lib.hasPrefix "/");
            description = "Absolute symlink source path.";
          };
          enable = lib.mkEnableOption "this symlink" // {
            default = true;
          };
          force = lib.mkEnableOption "overwriting an existing target";
        };
      }
    );
  };
  toEntries =
    base: files:
    lib.mapAttrsToList (name: file: {
      type = "symlink";
      inherit (file) source;
      target = "${base}/${name}";
      follow_symlinks = false;
      clobber = file.force;
    }) (lib.filterAttrs (_: file: file.enable) files);
  entries = toEntries homeDirectory cfg.files ++ toEntries config.xdg.configHome cfg.xdg.config.files;
  manifest = pkgs.writeText "smfh-files.json" (
    builtins.toJSON {
      version = 3;
      files = entries;
    }
  );
  state = lib.escapeShellArg cfg.stateFile;
  smfh = lib.getExe pkgs.smfh;
  jq = lib.getExe pkgs.jq;
in
{
  options.smfh = {
    files = fileOptions;
    xdg.config.files = fileOptions;
    stateFile = lib.mkOption {
      type = lib.types.addCheck lib.types.str (lib.hasPrefix "/");
      default = "${config.xdg.stateHome}/smfh/files.json";
      description = "Path to the last successfully applied manifest.";
    };
  };

  config = {
    home.activation.checkSmfhLinks = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
      smfhHandoffTargets=()
      smfhHandoffLinks=()
      function checkSmfhLinks() {
        local oldManifest=${state} oldFiles="" rows target previous desired force actual relative generation
        if [[ ! -f "$oldManifest" ]]; then
          oldManifest=${pkgs.writeText "empty-smfh-files.json" ''{"version":3,"files":[]}''}
        fi
        if [[ -n "''${oldGenPath:-}" && -e "$oldGenPath/home-files" ]]; then
          oldFiles="$(readlink -f "$oldGenPath/home-files")"
        fi
        rows="$(${jq} --raw-output --slurp '
          (.[0].files | INDEX(.target)) as $old |
          (.[1].files | INDEX(.target)) as $new |
          ($old + $new) | keys[] as $target |
          { target: $target, previous: $old[$target].source, desired: $new[$target].source,
            force: $new[$target].clobber }
        ' --compact-output "$oldManifest" ${manifest})" || return
        [[ -n "$rows" ]] || return 0
        while IFS= read -r row; do
          target="$(${jq} --raw-output '.target' <<< "$row")"
          desired="$(${jq} --raw-output '.desired // empty' <<< "$row")"
          if [[ -n "$desired" && ! -e "$desired" && ! -L "$desired" ]]; then
            errorEcho "Missing smfh link source '$desired'"
            return 1
          fi
          [[ -e "$target" || -L "$target" ]] || continue
          previous="$(${jq} --raw-output '.previous // empty' <<< "$row")"
          force="$(${jq} --raw-output '.force // false' <<< "$row")"
          if [[ "$force" == true && ( ! -d "$target" || -L "$target" ) ]]; then
            continue
          fi
          if [[ -L "$target" ]]; then
            actual="$(readlink "$target")"
            if [[ "$actual" == "$previous" || "$actual" == "$desired" ]]; then
              continue
            fi
            if [[ -n "$desired" && -n "$oldFiles" && "$target" == "$HOME/"* &&
                  "$actual" == "$oldFiles/''${target#"$HOME/"}" && -L "$actual" ]]; then
              continue
            fi
            if [[ -n "$desired" && "$target" == "$HOME/"* ]]; then
              relative="''${target#"$HOME/"}"
              generation="''${actual%/"$relative"}"
              generation="''${generation#${lib.escapeShellArg "${builtins.storeDir}/"}}"
              if [[ "$generation" == *-home-manager-files && "$generation" != */* &&
                    "$actual" == ${lib.escapeShellArg builtins.storeDir}/"$generation/$relative" &&
                    -L "$actual" ]]; then
                smfhHandoffTargets+=("$target")
                smfhHandoffLinks+=("$actual")
                continue
              fi
            fi
          fi
          errorEcho "smfh link collision at '$target'"
          return 1
        done <<< "$rows"
      }
      checkSmfhLinks || exit 1
    '';

    home.activation.linkSmfh =
      lib.hm.dag.entryBetween [ "reloadSystemd" "setupLaunchAgents" ] [ "linkGeneration" ]
        ''
          for index in "''${!smfhHandoffTargets[@]}"; do
            target="''${smfhHandoffTargets[$index]}"
            if [[ -L "$target" && "$(readlink "$target")" == "''${smfhHandoffLinks[$index]}" ]]; then
              run rm -- "$target"
            fi
          done
          if [[ ${if entries == [ ] then "1" else "0"} == 0 || -f ${state} ]]; then
            run ${smfh} diff --fallback ${manifest} ${state}
            run install -Dm600 ${manifest} ${state}.new
            run mv -f ${state}.new ${state}
          fi
        '';
  };
}
