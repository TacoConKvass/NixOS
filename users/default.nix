{ pkgs, ... }:
{
	nixpkgs = {
    config = {
    	allowUnfree = true;
    	packageOverrides = pkgs: {
    		unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
    	};
  	};
	};

	users.users.taco = {
    isNormalUser = true;
    description = "Taco";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      comma
      fastfetch
      git
			dotnet-sdk_8
			unstable.zig
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
