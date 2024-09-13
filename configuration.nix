{ config, pkgs, ... }:
{
	imports = [
			./hardware-configuration.nix
			./users
	];

	# Bootloader.
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.useOSProber = true;

	# Enable networking
	networking.hostName = "taco-bell";
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "Europe/Warsaw";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_GB.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pl_PL.UTF-8";
		LC_IDENTIFICATION = "pl_PL.UTF-8";
		LC_MEASUREMENT = "pl_PL.UTF-8";
		LC_MONETARY = "pl_PL.UTF-8";
		LC_NAME = "pl_PL.UTF-8";
		LC_NUMERIC = "pl_PL.UTF-8";
		LC_PAPER = "pl_PL.UTF-8";
		LC_TELEPHONE = "pl_PL.UTF-8";
		LC_TIME = "pl_PL.UTF-8";
	};

	# Enable the X11 windowing system.
	# Enable the KDE Plasma Desktop Environment.
	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "pl";
		variant = "";
	};

	# Configure console keymap
	console.keyMap = "pl2";

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
		nixvim = {
			enable = true;
			defaultEditor = true;

			opts = {
				relativenumber = true;
				number = true;

				expandtab = true;
				shiftwidth = 2;
				tabstop = 2;
			};

			colorschemes.gruvbox.enable = true;
		};
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# NixOS version
	system.stateVersion = "24.05";

}
