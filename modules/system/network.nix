{
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh.enable = true;
}
