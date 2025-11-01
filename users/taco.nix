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

    files = let cfg = "${home}/.config"; in {
        "${home}/.bashrc".source = ./../dotfiles/bash;
        "${cfg}/ghostty/config".source = ./../dotfiles/ghostty;
        "${cfg}/niri/config.kdl".source = ./../dotfiles/niri.kdl;
        "${cfg}/waybar/style.css".source = ./../dotfiles/waybar.css;
        "${cfg}/waybar/config.jsonc".source = ./../dotfiles/waybar.jsonc;
        "${cfg}/wallpaper.png".source = ./../dotfiles/wallpaper.png;
        "${cfg}/fuzzel/fuzzel.ini".source = ./../dotfiles/fuzzel.ini;
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
