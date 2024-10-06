{ ... }:
{
	imports = [
		../../users
		../../modules
	];

	programs = {
		firefox.enable = true;
	};

	modules = {
		nixvim.enable = true;
		internalisation.enable = true;
	};

	# Enable networking
	networking.hostName = "taco-wsl";
	networking.networkmanager.enable = true;

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# Enable flakes
	nix.settings.experimental-features = ["nix-command" "flakes"];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	
	# NixOS version
	system.stateVersion = "24.05";
}
