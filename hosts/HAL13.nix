{ pkgs, ... } : { 
  networking.hostName = "HAL13";
  networking.resolvconf.enable = false;

  time.timeZone = "Eurpoe/Warsaw";

  environment.systemPackages = [
    pkgs.fastfetch
    pkgs.git
    pkgs.helix
  ];

  environment.sessionVariables.EDITOR = "hx";

  services.openssh = {
    enable = true;
    allowSFTP = true;
    ports = [ 55 ];
    settings = {
      AllowUsers = [ "taco" ];
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}
