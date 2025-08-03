{ config, pkgs, ... } : {
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
                home = config.user.home;
            };
        };
        
        git = {
            enable = true;
            username = "TacoConKvass";
            email = "e_frun@o2.pl";
        };
    };
    
    system.stateVersion = "24.05";
    
    environment.etcBackupExtension = ".bak";
    
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';
}
