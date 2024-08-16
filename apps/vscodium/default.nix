{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.apps.vscodium;
  # patch vscodium to enable copilot support
  productJson =
    if pkgs.stdenv.isDarwin then
      "Applications/VSCodium.app/Contents/Resources/app/product.json"
    else
      "lib/vscode/resources/app/product.json";
  package = pkgs.symlinkJoin {
    name = "vscodium-patched";

    inherit (pkgs.vscodium)
      pname
      version
      passthru
      meta
      ;

    paths = [ pkgs.vscodium ];

    postBuild = ''
      rm $out/${productJson}
      ${lib.getExe pkgs.gnused} -e 's/"GitHub.copilot": \["inlineCompletionsAdditions"\]/"GitHub.copilot": ["inlineCompletions","inlineCompletionsNew","inlineCompletionsAdditions","textDocumentNotebook","interactive","terminalDataWriteEvent"]/' ${pkgs.vscodium}/${productJson} > $out/${productJson}
    '';
  };

  prefix = if pkgs.stdenv.isDarwin then "Library/Application Support" else ".config";
in
{
  options.dotfiles.apps.vscodium.enable = lib.mkEnableOption "vscodium";

  config = lib.mkMerge [
    {
      # set default extensions for both vscode and vscodium
      programs.vscode.extensions =
        (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx; [
          bmalehorn.vscode-fish
          davidanson.vscode-markdownlint
          editorconfig.editorconfig
          elixir-lsp.elixir-ls
          elixir-tools.elixir-tools
          esbenp.prettier-vscode
          foxundermoon.shell-format
          golang.go
          github.github-vscode-theme
          jnoortheen.nix-ide
          mkhl.direnv
          naumovs.color-highlight
          redhat.vscode-yaml
          skellock.just
          tamasfe.even-better-toml
          timonwong.shellcheck
        ])
        ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          github.copilot
          github.copilot-chat
          ms-vsliveshare.vsliveshare
          # phoenixframework.phoenix
        ]);
    }
    (lib.mkIf cfg.enable {
      home.file."${prefix}/VSCodium/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/keybindings.json";
      home.file."${prefix}/VSCodium/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/settings.json";

      # they say you shouldn't modify the system in this phase, but... 🤷‍♂️
      home.activation.own-vscodium-snippets = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        if [ ! -h "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets" ]; then
          rm -rfv "${config.home.homeDirectory}/${prefix}/VSCodium/User/snippets"
        fi
      '';
      home.file."${prefix}/VSCodium/User/snippets".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/apps/vscodium/snippets";

      programs.vscode = {
        enable = true;
        package = package;

      };
    })
  ];
}
