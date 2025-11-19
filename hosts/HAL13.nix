{ pkgs, unstable, zen-browser, ... } : {
    imports = [ ./../modules ];

    modules.dev = {
        zig = {
            enable = true;
            package = unstable.zig_0_15;
            lsp = unstable.zls_0_15;
        };
        rust = true;
        cSharp = true;
    };

    features.wm = {
        enable = true;
        apps = [
            pkgs.ghostty
            zen-browser.twilight
        ];
    };

    networking.hostName = "HAL13";

    environment.systemPackages = [
        pkgs.fastfetch
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
