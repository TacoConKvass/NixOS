{ pkgs, ... } : {
    imports = [ ./../../modules ];

    modules = {
        dev.zig = true;
        dev.rust = true;
        dev.neovim = true;
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";

    system.build.apply = "echo Hi!";
}
