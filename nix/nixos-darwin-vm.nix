{
  inputs,
  withSystem,
  self,
  ...
}: {
  flake.nixosConfigurations.darwin-vm = withSystem "aarch64-linux" (
    {
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

            swapDevices = [];

            networking.useDHCP = lib.mkDefault true;
          })
          {
            _module.args.nixinate = {
              host = "192.168.64.31";
              sshUser = "root";
              buildOn = "remote";
              substituteOnTarget = true;
            };
          }
          {
            users.users.adam = {
              isNormalUser = true;
              extraGroups = ["wheel" "audio"];
              shell = pkgs.fish;
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIaAFecMxP1SAxdCZvWZFNBAK6ByeG9Mvc5HUysMbJ9y emat"
              ];
            };

            home-manager.users.adam = {
              imports = self.homeModules.${system};
            };
          }
        ];
      }
  );
}
