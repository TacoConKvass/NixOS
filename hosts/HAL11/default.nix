{ config, pkgs, unstable, zen-browser, ... } : let
    user = config.users.users.nixos;
in{
    imports = [ ./../../modules ];

    modules = {
        dev.zig = {
            enable = true;
            package = unstable.zig_0_15;
            languageServer = unstable.zls_0_15;
        };
        dev.rust = true;
        dev.cSharp = true;

        dotfiles = {
            definitions.bashrc = {
                path = ".bashrc";
                source = ./../../dotfiles/bash;
            };
            definitions.ghostty = {
                path = ".config/ghostty";
                source = ./../../dotfiles/ghostty;
                overwrite = true;
            };
            inherit user;
        };

        neovim = {
            enable = true;
            config = {
                pull = true;
                repository = {
                    url = "https://github.com/TacoConKvass/nvim";
                    branch = "lazy";
                };
                user = user;
            };
        };

        git = {
            enable = true;
            config = {
                enable = true;
                username = "TacoConKvass";
                email = "e_frun@o2.pl";
                gcm = {
                    enable = true;
                    storeType = "gpg";
                };
                user = user;
            };
        };
    };

    networking.hostName = "HAL11";

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.ghostty

        unstable.niri
        pkgs.fuzzel

        zen-browser.twilight
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
