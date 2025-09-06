{ config, pkgs, ... } : let
    user = config.user;
in {
    imports = [
        ./../../modules
        ./android-proxy
    ];

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
                user = user;
            };
            additionalPackages = [ pkgs.ripgrep ];
        };

        git = {
            enable = true;
            config = {
                enable = true;
                username = "TacoConKvass";
                email = "e_frun@o2.pl";
                user = user;
            };
        };
    };

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.ncurses
    ];

    system.stateVersion = "24.05";

    environment.etcBackupExtension = ".bak";
    
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';
}
