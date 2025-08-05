{ lib, ... }:

let
  # Define the disk you want to format.
  # Use `lsblk` on the installer to find the correct device name.
  disk = "/dev/nvme0n1";
in
{
  # Disko configuration for UEFI + LUKS + BTRFS
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # Tip: Set your password in a secret file managed by agenix
                # passwordFile = "/run/secrets/luks_password";
                # For initial setup, you can use `password.text = "your-password-here";`
                # but it's insecure. It's better to be prompted for it.
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Force creation
                  subvolumes = {
                    # Root subvolume, mounted at /
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Home subvolume
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Nix store subvolume
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Steam subvolume - no snapshots
                    # This prevents backups of large game libraries
                    "@steam" = {
                      mountpoint = "/home/nohi/.local/share/Steam";
                      mountOptions = [ "compress=zstd" "noatime" "nodatacow" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}