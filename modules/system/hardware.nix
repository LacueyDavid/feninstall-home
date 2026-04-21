{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.upower.enable = true;
  services.fwupd.enable = true;
}
