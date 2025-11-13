{ config, pkgs, unstable, ... } : let
    user = config.user;
    home = user.home;
in {
    imports = [
        ./../modules
        ./android-proxy.nix
    ];
    
    modules = {
        dev.zig = {
            enable = true;
            package = unstable.zig_0_15;
            lsp = unstable.zls_0_15;
        };
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
    
    files = {
        "${home}/.bashrc".source = ./../dotfiles/bash;
    };

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.ncurses
    ];

    system.stateVersion = "24.05";

    environment.etcBackupExtension = ".bak";
    environment.motd = "";

    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';
}
