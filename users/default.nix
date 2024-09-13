{ config, pkgs, ... }:
{
  users.users.taco = {
    isNormalUser = true;
    description = "Taco";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      comma
      fastfetch
      git
    ];
  };

  security.sudo.extraRules = [
    {
      users = ["taco"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
