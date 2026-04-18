# Slightly altered and reorganised hardware-configuration.nix
# from the Acer Aspire 1360 laptop
{ config, lib, pkgs, modulesPath, ... }: {
    imports = [ 
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "firewire_ohci" "uhci_hcd" "ehci_pci" "pata_via" "usbhid" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    
    boot.loader.grub = {
        enable = true;
        device = "/dev/sda";
    };

    services.pulseaudio.enable = true;

    fileSystems."/" = {
        device = "/dev/disk/by-label/root";
        fsType = "ext4";
    };
    swapDevices = [ 
        { device = "/dev/disk/by-label/swap"; }
    ];

    networking.useDHCP = lib.mkDefault true;

    # CPU arch
    nixpkgs.hostPlatform = lib.mkDefault "i686-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
