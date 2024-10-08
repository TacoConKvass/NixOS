{ lib, config, ... } : {
	
	options = {
		modules.desktop.enable = lib.mkEnableOption "Enables the desktop environment";	
		modules.desktop.desktopManager = lib.mkOption {
			type = lib.types.enum ["plasma5" "plasma6" "gnome"];
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
		
		services = {
			# Enable the X11 windowing system.
			xserver.enable = true;
			
			# Choose desktop environment
			xserver.desktopManager = {
				plasma5.enable = lib.mkIf (config.modules.desktop.desktopManager == "plasma5");
				gnome.enable = lib.mkIf (config.modules.desktop.desktopManager == "gnome");
			};
			desktopManager.plasma6.enable = lib.mkIf (config.modules.desktop.desktopManager == "plasma6");

			# Choose display manager
			xserver.displayManager = {
				sddm.enable = lib.mkIf (config.modules.desktop.displayManager == "sddm");
				gdm.enable = lib.mkIf (config.modules.desktop.displayManager == "gdm");
			};
		};

		# Configure keymap in X11
		services.xserver.xkb = {
			layout = "pl";
			variant = "";
		};
	};
}
