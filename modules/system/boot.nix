{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "uas"
    "sr_mod"
    "ahci"
    "sd_mod"
  ];

  boot.initrd.luks.devices."crypted" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/crypted--vg-root";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/crypted--vg-home";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/mapper/crypted--vg-swap"; }
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-ESP";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };
}
