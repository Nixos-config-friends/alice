# ⚠️ EXEMPLE À REMPLACER ⚠️
# Ce fichier doit être celui généré sur le MacBook pendant l'installation :
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
# Il contient les vrais identifiants des partitions (et du disque chiffré).
# Celui-ci ne sert qu'à faire passer la CI en attendant.
{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.luks.devices."luks-REMPLACER".device = "/dev/disk/by-uuid/REMPLACER-UUID-LUKS";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REMPLACER-UUID-RACINE";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REMPLACER-UUID-BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
