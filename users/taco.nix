{ config, pkgs, ... } : let 
    taco = config.users.users.taco;
    home = taco.home;
in {
    imports = [ ./../modules ];
    
    users.users.taco = {
        isNormalUser = true;
        home = "/home/taco";
        createHome = true;
        description = "TacoConKvass";
        group = "users";
        extraGroups = [ "wheel" ];
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeh8y/aKohPIq4/+hKH6CocM03l3cr8IaoXi21+24Wo taco"
        ];
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

    files = let cfg = "${home}/.config"; in {
        "${home}/.bashrc".source = ./../dotfiles/bash;
        "${cfg}/niri/config.kdl".source = ./../dotfiles/niri.kdl;
        "${cfg}/waybar/style.css".source = ./../dotfiles/waybar.css;
        "${cfg}/waybar/config.jsonc".source = ./../dotfiles/waybar.jsonc;
        "${cfg}/wallpaper.png".source = ./../dotfiles/wallpaper.png;
        "${cfg}/fuzzel/fuzzel.ini".source = ./../dotfiles/fuzzel.ini;
    };
}
