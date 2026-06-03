{ pkgs, ... } : {
  features = {
    dev.dotnet = true;

    wm = {
      enable = true;
      apps = [ pkgs.foot ];
      fonts = [ pkgs.nerd-fonts.jetbrains-mono ];
    };
  };
  
  networking.hostName = "HAL13";
  networking.resolvconf.enable = false;

  time.timeZone = "Eurpoe/Warsaw";

  environment.systemPackages = [
    pkgs.fastfetch
  ];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    ports = [ 55 ];
    settings = {
      AllowUsers = [ "taco" ];
      PermitRootLogin = false;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}
