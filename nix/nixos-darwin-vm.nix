{
  inputs,
  withSystem,
  self,
  ...
}: {
  flake.nixosConfigurations.darwin-vm = withSystem "aarch64-linux" (
    {
      inputs',
      pkgs,
      system,
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          inputs.home-manager.nixosModules.home-manager
          ({
            lib,
            modulesPath,
            ...
          }: {
            # core config
            imports = [
              (modulesPath + "/profiles/qemu-guest.nix")
            ];

            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            services.openssh.enable = true;
            # services.openssh.permitRootLogin = "yes";

            system.stateVersion = "22.11";

            boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod"];
            boot.initrd.kernelModules = [];
            boot.kernelModules = [];
            boot.extraModulePackages = [];

            fileSystems."/" = {
              device = "/dev/disk/by-uuid/4b18db0b-b22d-42a2-93a8-5b105546448b";
              fsType = "btrfs";
            };

            fileSystems."/boot" = {
              device = "/dev/disk/by-uuid/196A-AD9D";
              fsType = "vfat";
            };

            swapDevices = [
              {
                device = "/dev/disk/by-uuid/f798d1ca-d368-43ec-8235-df4f2de22cca";
              }
            ];

            networking.useDHCP = lib.mkDefault true;
          })
          {
            # nixinate settings
            _module.args.nixinate = {
              host = "darwin-vm"; # needs ssh/config
              sshUser = "root";
              buildOn = "remote";
              substituteOnTarget = true;
              hermetic = false;
            };
          }
          {
            networking.hostName = "darwin-vm";

            environment.systemPackages = [
              pkgs.git
            ];

            nix = {
              settings = {
                auto-optimise-store = true;

                allowed-users = ["@wheel"];
                trusted-users = ["root" "@wheel"];
                substituters = [
                  "https://nix-config.cachix.org"
                  "https://nix-community.cachix.org"
                ];
                trusted-public-keys = [
                  "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
              };
              extraOptions = ''
                # builders-use-substitutes = true
                experimental-features = nix-command flakes
                # flake-registry = /etc/nix/registry.json
                # don't let nix fill the disk
                min-free = ${toString (1 * 1024 * 1024 * 1024)}
                max-free = ${toString (3 * 1024 * 1024 * 1024)}
              '';
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 21d";
              };

              registry = {
                nixpkgs.flake = inputs.nixpkgs;
              };
            };
            # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowUnsupportedSystem = true;

            security.sudo = {
              enable = true;
              wheelNeedsPassword = false;
            };

            users.users.adam = {
              isNormalUser = true;
              extraGroups = ["audio" "video" "tty" "wheel"];
              shell = pkgs.fish;
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIaAFecMxP1SAxdCZvWZFNBAK6ByeG9Mvc5HUysMbJ9y emat"
              ];
            };

            # Qemu
            services.spice-vdagentd.enable = true;

            # For now, we need this since hardware acceleration does not work.
            environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

            # We expect to run the VM on hidpi machines.
            hardware.video.hidpi.enable = true;

            home-manager.users.adam = {
              nixpkgs.overlays = [self.overlays.default];

              imports = self.homeModules.darwin-vm;
            };

            home-manager.extraSpecialArgs = {
              inherit inputs inputs';
            };
          }
          {
            virtualisation.docker.enable = true;
            users.users.adam.extraGroups = ["docker"];
          }
        ];
      }
  );
}
