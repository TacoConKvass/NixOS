{ pkgs, lib, config, ... } @ inputs : {
    imports = [ 
        ./../modules
        ./hardware/aspire-1360.nix
    ];

    # disable features either not supporting 32 bit systems
    # or those that are too resource intensive
    modules.git.config.gcm.enable = lib.mkForce false;
    features.wm.enable = lib.mkForce false;

    networking.hostName = "NCC-686";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Warsaw";

    modules.dev.rust = true;
    modules.neovim = {
        enable = true;
        config = {
            pull = true;
            repository = {
                url = "https://github.com/TacoConKvass/nvim";
                branch = "lazy";
            };
            user = inputs.config.users.users.taco;
        };
    };

    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.cloudflared
        pkgs.lynx
        pkgs.tmux
    ];

    # Disable suspend on lid close
    powerManagement.enable = false;
    services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
    };

    services.getty.greetingLine = ">>> ${config.networking.hostName} (${config.nixpkgs.hostPlatform.system}) <<<";

    services.openssh.enable = true;
    programs.ssh.extraConfig = ''
        Host builder
            Hostname        192.168.11.13
            Port            55
            User            taco
            IdentityFIle    /home/taco/.env/hal13
    '';

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "pl";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "23.11";
}
