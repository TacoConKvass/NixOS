{ pkgs, zen-browser, ... } : {
    imports = [ ./../modules ];

    modules.dev.cSharp = true;

    features.wm = {
        enable = true;
        apps = [
            pkgs.foot
            zen-browser.twilight
        ];
        fonts = [
            pkgs.nerd-fonts.jetbrains-mono
        ];
    };

    networking.hostName = "HAL13";

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.helix
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
