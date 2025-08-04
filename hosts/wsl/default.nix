{ config, ... } : let
    homeDir = config.users.users.nixos.home;
in {
    imports = [ ./../../modules ];

    modules = {
        dev.zig = true;
        dev.rust = true;

        neovim = {
            enable = true;
            config = {
                pull = true;
                repository = {
                    url = "https://github.com/TacoConKvass/nvim";
                    branch = "lazy";
                };
                home = homeDir;
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
                home = homeDir;
            };
        };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.stateVersion = "24.11";
}
