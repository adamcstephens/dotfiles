{ inputs, withSystem, ... }:
{
  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { inputs', ... }:
    let
      pkgs = inputs'.nixpkgs.legacyPackages;
    in
    {
      distrobuilder = pkgs.callPackage ./distrobuilder.nix { };
      # incus = pkgs.callPackage ./incus.nix { };
      xmonad = pkgs.callPackage ./xmonad.nix { };
    }
  );

  perSystem =
    {
      inputs',
      pkgs-unstable,
      system,
      ...
    }:
    let
      npins = import ../npins;
    in
    {
      _module.args =
        if (system == "x86_64-linux") then
          {
            inherit npins;

            pkgs-unstable = import inputs.nixpkgs {
              inherit system;
              overlays = [ ];
            };
          }
        else
          {
            inherit npins;
            pkgs-unstable = inputs'.nixpkgs.legacyPackages;
          };

      devShells = {
        dotfiles = pkgs-unstable.callPackage ./dotfiles.nix { inherit inputs; };

        cd = pkgs-unstable.callPackage ./cd.nix { };
        ci = pkgs-unstable.callPackage ./ci.nix { inherit inputs; };

        c = pkgs-unstable.callPackage ./c.nix { };
        elixir = pkgs-unstable.callPackage ./elixir.nix { };
        go = pkgs-unstable.callPackage ./go.nix { };
        js = pkgs-unstable.callPackage ./js.nix { };
        media = pkgs-unstable.callPackage ./media.nix { };
        nixpkgs = pkgs-unstable.callPackage ./nixpkgs.nix { };
        ocaml = pkgs-unstable.callPackage ./ocaml.nix { inherit inputs; };
        python = pkgs-unstable.callPackage ./python.nix { };
        rust = pkgs-unstable.callPackage ./rust.nix { };
        zig = pkgs-unstable.callPackage ./zig.nix { };
      };
    };
}
