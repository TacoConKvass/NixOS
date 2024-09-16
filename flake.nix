{
	description = "Taco bell";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		nixvim.url = "github:nix-community/nixvim/nixos-24.05";
	};

	outputs = { nixpkgs, ... } @ inputs: {

		nixosConfigurations.taco-bell = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hosts/taco-bell
        inputs.nixvim.nixosModules.nixvim
			];
		};
	};
}
