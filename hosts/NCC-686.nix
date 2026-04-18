{ pkgs, lib, ... } @ inputs : {
    imports = [ 
        ./../modules
        ./hardware/aspire-1360.nix
    ];

    # disable features, either not supporting 32 bit systems
    # or those that are too resource intensive
    modules.git.config.gcm.enable = lib.mkForce false;
    features.wm.enable = lib.mkForce false;

    networking.hostName = "NCC-686";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Warsaw";

    modules.neovim = {
        enable = true;
        config = {
            pull = true;
            repository = "https://github.com/TacoConKvass/nvim";
            branch = "lazy";
            user = users.users.taco;
        };
    };

    environment.systemPackages = [
        pkgs.fastfetch
    ];

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "pl";
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # nixbuild.net setup
    programs.ssh = {
        extraConfig = ''
            Host eu.nixbuild.net
              PubkeyAcceptedKeyTypes ssh-ed25519
              ServerAliveInterval    60
              IPQoS                  throughput
              IdentityFile           /home/taco/.env/nixbuild
              SetEnv                 NIXBUILDNET_REUSE_BUILD_FAILURES=0
        '';
        knownHosts = {
            nixbuild = {
                hostNames = [ "eu.nixbuild.net" ];
                publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
            };
        };
   };

    nix = {
        distributedBuilds = true;
        buildMachines = [{
            hostName = "eu.nixbuild.net";
            system = "i686-linux";
            maxJobs = 100;
            supportedFeatures = [ "benchmark" "big-parallel" ];
        }];
    };

    system.stateVersion = "23.11";
}
