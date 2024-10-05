{ ... }:
{
        imports = [
 		../../users
		../../modules
        ];

        # Enable networking
        networking.hostName = "taco-wsl";
        networking.networkmanager.enable = true;

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
	};

        # Allow unfree packages
        nixpkgs.config.allowUnfree = true;

        # NixOS version
        system.stateVersion = "24.05";

}
