{ config, pkgs, ... } : let 
    taco = config.users.users.taco;
    home = taco.home;
in {
    imports = [ ./../modules ];
    
    users.users.taco = {
        createHome = true;
        description = "TacoConKvass";
        extraGroups = [ "wheel" ];
        group = "users";
        home = "/home/taco";
        shell = pkgs.bash;
    };

    files = {
        "${home}/.bashrc".source = ./../dotfiles/bash;
        "${home}/.config/ghostty/config".source = ./../dotfiles/ghostty;
        "${home}/.config/niri/config.kdl".source = ./../dotfiles/niri.kdl;
    };

    modules.neovim = {
        enable = true;
        config = {
            pull = true;
            repository = {
                url = "https://github.com/TacoConKvass/nvim";
                branch = "lazy";
            };
            user = taco;
        };
    };

    modules.git = {
        enable = true;
        config = {
            enable = true;
            username = "TacoConKvass";
            email = "e_frun@o2.pl";
            gcm = {
                enable = true;
                storeType = "gpg";
            };
            user = taco;
        };
    };
}
