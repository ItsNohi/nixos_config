# My NixOS Configuration

This repository contains the complete, declarative configuration for my NixOS machines, managed with Nix Flakes.

## Directory Structure

-   `/hosts`: Contains machine-specific configurations (hardware, partitioning).
    -   `/zephyrus-g14`: Configs for the laptop.
-   `/modules`: Contains shared configuration modules.
    -   `/nixos`: System-level modules (KDE, base settings).
    -   `/home-manager`: User-level modules (shared shell configs, etc.).
-   `/users`: Contains user-specific package lists and dotfiles managed by `home-manager`.
-   `/secrets`: Holds encrypted secret files and the `secrets.nix` definition file for `agenix`.
-   `flake.nix`: The entry point that ties everything together.

## First-Time Installation on a New Machine

**1. Boot from NixOS Installer**

Boot your new machine using a recent NixOS installer USB drive (ensure it's a version that supports flakes, e.g., 23.11 or newer).

**2. Connect to the Internet**

Connect to WiFi or Ethernet.

```bash
# For WiFi
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "Your-SSID"
```

**3. Partition and Format with Disko**

First, clone your configuration repository.

```bash
git clone <your-git-repo-url> /mnt/etc/nixos
cd /mnt/etc/nixos
```

Now, run `disko` to format the drive. **THIS WILL WIPE THE TARGET DISK.**

```bash
# Make sure you are in the flake directory
# The --flake argument points to the nixosConfiguration to use
# and the `disko` attribute we defined.
sudo nix run github:nix-community/disko -- --mode disko ./hosts/zephyrus-g14#disko
```

Disko will partition, create the LUKS container, format BTRFS, and mount everything correctly under `/mnt`.

**4. Set up Secrets with Agenix**

You need to create your secret files.

```bash
# Generate a host key on the installer environment
ssh-keygen -t ed25519 -f ./host_key

# Add the public key from ./host_key.pub to secrets/secrets.nix

# Now, create and encrypt your LUKS password
agenix -e luks_password -i ./host_key
# This will open your $EDITOR. Type your password and save.
# It will create secrets/luks_password.age
```

**5. Install NixOS**

Now you can run the NixOS installer, pointing it to your flake.

```bash
nixos-install --flake .#zephyrus-g14
```

The installer will build your system, including all packages and `home-manager` configurations. It will prompt for your user password during the process.

**6. Reboot and Enjoy**

After installation, reboot the system. You will be prompted for your LUKS password at boot. Log in, and your full environment, including KDE, Alacritty, and Neovim configs, will be ready.

## Managing Secrets

-   **To add a new secret:** `agenix -e my_new_secret.age`
-   **To edit an existing secret:** `agenix -e luks_password.age`
-   **To rekey files** (e.g., after adding a new host): `agenix -r`

You only need the private host key (`/etc/ssh/ssh_host_ed25519_key`) on the target machine. It's generated automatically by NixOS. You can get the public key from a running machine with `cat /etc/ssh/ssh_host_ed25519_key.pub`.