{ pkgs, unstable, zen-browser, ... } : {
    imports = [ ./../modules ];

    modules.dev = {
        zig = {
            enable = true;
            package = unstable.zig_0_15;
            languageServer = unstable.zls_0_15;
        };
        rust = true;
        cSharp = true;
    };

    networking.hostName = "HAL11";

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.ghostty

        unstable.niri
        pkgs.fuzzel
        pkgs.waybar
        pkgs.swaybg

        zen-browser.twilight
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
