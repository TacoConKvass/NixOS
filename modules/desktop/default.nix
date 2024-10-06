{ lib, config, ... } : {
	
	options = {
		modules.desktop.enable = lib.mkfEnableOption "Enables the desktop environment";	
		modules.desktop.desktopManager = lib.mkOption {
			type = lib.types.enum ["plasma" "plasma6" "gnome"];
			default = "plasma6";
			description = "Which desktop environment to use, defaults to Plasma 6";
		};
		modules.desktop.displayManager = {
			type = lib.types.enum ["gdm" "sddm"];
			default = "sddm";
			description = "Which display manager to use, defaults to sddm";
		};
	};

	config = lib.mkIf config.modules.desktop.enable {
		# Enable the X11 windowing system.
		# Enable the KDE Plasma Desktop Environment.
		services.xserver.enable = true;
		
		# Choose display manager
		services.displayManager."${config.modules.desktop.displayManager}".enable = true;

		# Choose desktop environment
		services.desktopManager."${config.modules.desktop.desktopManager}".enable = true;

		# Configure keymap in X11
		services.xserver.xkb = {
			layout = "pl";
			variant = "";
		};
	};
}
