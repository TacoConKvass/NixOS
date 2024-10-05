{
	description = "Taco bell";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		nixvim.url = "github:nix-community/nixvim/nixos-24.05";
		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
	};

	outputs = { nixpkgs, ... } @ inputs: {
		nixosConfigurations.taco-bell = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hosts/taco-bell
				inputs.nixvim.nixosModules.nixvim
			];
		};
		
		nixosConfigurations.taco-wsl = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hosts/wsl
				inputs.nixvim.nixosModules.nixvim
				inputs.nixos-wsl.nixosModules.default {
	  				system.stateVersion = "24.05";
					wsl.enable = true;
	    			}
			];
		};
	};
}
