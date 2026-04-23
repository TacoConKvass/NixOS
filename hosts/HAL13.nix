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
    time.timeZone = "Europe/Warsaw";

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.helix
    ];

    services.openssh = {
        enable = true;
        allowSFTP = true;
        ports = [ 55 ];
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ "taco" "root" ];
        };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
