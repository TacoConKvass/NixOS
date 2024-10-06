{ ... } : {
	imports = [
		../../hardware-configuration.nix
		../../users
		../../modules
	];

	# Bootloader.
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.useOSProber = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "pl";
		variant = "";
	};

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

	programs = {
		firefox.enable = true;
	};

	modules = {
		nixvim.enable = true;
		internalisation.enable = true;
		desktop.enable = true;
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# NixOS version
	system.stateVersion = "24.05";

}
