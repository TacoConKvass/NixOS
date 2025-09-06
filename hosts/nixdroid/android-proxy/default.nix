{ config, lib, ... } : let
    environment = config.environment;
    system = config.system;
in {
    options = {
        environment = {
            systemPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [];
                description = "Proxy to Nix-on-droid's `environment.packages`";
            };
        };
        system = {
            activationScripts = lib.mkOption {
                type = lib.types.attrs;
                default = {};
                description = "Proxy to Nix-on-droid's `build.activationAfter`";
            };
        };
        user = {
            name = lib.mkOption {
                type = lib.types.str;
                default = config.user.userName;
                description = "Proxy to Nix-on-droid's `user.userName`";
                readOnly = true;
            };
        };
    };

    config = {
        environment.packages = environment.systemPackages;
        build.activationAfter = system.activationScripts;
    };
}
